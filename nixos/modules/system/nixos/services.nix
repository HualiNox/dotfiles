/**
  系统公共服务配置。

  当前只配置 OpenSSH：限制登录用户、关闭交互式认证，并兼容 Jenkins SSH Launcher。
*/
{ ... }:

{
  # openssh 配置
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";

      # 只允许明确列出的本地账号通过 SSH 登录。
      AllowUsers = [
        "hualimao"
        "jenkins"
      ];
      MaxAuthTries = 3;
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"

        # 兼容 Jenkins SSH Launcher / Trilead
        "hmac-sha2-256"
        "hmac-sha2-512"
      ];
    };

    # Jenkins 只允许公钥登录，避免 CI 用户落回密码认证。
    extraConfig = ''
      Match User jenkins
          PasswordAuthentication no
          KbdInteractiveAuthentication no
          AuthenticationMethods publickey
    '';
  };
}
