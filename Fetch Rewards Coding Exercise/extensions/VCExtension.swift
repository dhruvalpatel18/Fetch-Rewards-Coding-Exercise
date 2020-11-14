import Foundation
import SVProgressHUD

extension ViewController {
    func showSVProgressHUD(message: String) {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show(withStatus: message)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setMinimumSize(CGSize(width: 200, height: 30))
    }

    func hideSVProgressHUD() {
        SVProgressHUD.dismiss()
    }

    func toast(message: String) {
        toastView.isHidden = false
        toastMessage.text = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.toastView.isHidden = true
        }
    }
}
