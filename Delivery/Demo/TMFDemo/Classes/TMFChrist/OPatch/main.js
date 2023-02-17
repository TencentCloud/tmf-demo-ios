class TMFChristViewController {
    // 替换viewDidLoad方法
    viewDidLoad() {
        var taskName = "tmfOPTest";
        self.origin__viewDidLoad();
        log("viewDidLoad hook start");
        // 修复图片
        var tmfObject = require('TMFChristManager').sharedManager();
        var imgpath = tmfObject.resourceDirectory() + "/"+taskName+"/success.png";
        log(imgpath);
        var image = require('UIImage').imageWithContentsOfFile(imgpath);
        self.imgView().setImage(image);
        // 修复方法
        self.but1().setTitle_forState("修复后-不崩溃"+taskName, 0);
        self.but1().setTitleColor_forState(require('UIColor').greenColor(), 0);

        log("viewDidLoad hook finish");
    }
    butclick(button) {
        if (10 == button.tag()) {
            self.testFix();
        } else if (20 == button.tag()) {
            _callCFunc2();
        } else if (30 == button.tag()) {
            _showAlertTitle("已修复成功，无需再修复。");
        }
    }
    loadfixMethod1(){
        log('TMFChristViewController_loadfixMethod_hook');
    }
}
