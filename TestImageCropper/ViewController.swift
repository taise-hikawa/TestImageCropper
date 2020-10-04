//
//  ViewController.swift
//  TestImageCropper
//
//  Created by Sakurako Shimbori on 2020/10/05.
//

import UIKit
import RSKImageCropper

class ViewController: UIViewController,UINavigationControllerDelegate , UIImagePickerControllerDelegate,RSKImageCropViewControllerDelegate {
    
    

    @IBAction func buttonAction(_ sender: Any) {
        //カメラかフォトライブラリーどちらから画像を取得するか選択
                let alertController = UIAlertController(title: "確認", message: "選択してください", preferredStyle: .actionSheet)
                // カメラが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    let cameraAction = UIAlertAction(title: "カメラ", style: .default, handler: {(action) in
                        //(1)UIImagePickerControllerのインスタンスを作成
                        let imagePickerController = UIImagePickerController()
                        //(2)sourceTypeにcameraを設定
                        imagePickerController.sourceType = .camera
                        //(3)delegate設定
                        imagePickerController.delegate = self
                        //(4)モーダルビューで表示
                        self.present(imagePickerController,animated: true,completion: nil)
                    })
                    alertController.addAction(cameraAction)
                }
                //フォトライブラリーが利用可能かチェック
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    //フォトライブラリーを起動するための選択肢を表示
                    let photoLibraryAction = UIAlertAction(title: "フォトライブラリー", style: .default, handler: {(action) in
                        //フォトライブラリーを起動
                        let imagePickerController = UIImagePickerController()
                        imagePickerController.sourceType = .photoLibrary
                        imagePickerController.delegate = self
                        self.present(imagePickerController,animated: true,completion: nil)
                    })
                    alertController.addAction(photoLibraryAction)
                }
        
        //キャンセルの選択肢を定義
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //iPadで落ちてしまう対策
        alertController.popoverPresentationController?.sourceView = view
        
        //選択肢を表示
        present(alertController,animated: true,completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    //次の画面遷移する時に渡す画像を格納する場所
    var captureImage : UIImage?
    var imageCropVC:RSKImageCropViewController!
    //(1)撮影が終わった時に呼ばれるdelegateメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        //(2)撮影した画像を配置したpictureImageに渡す
        captureImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        imageCropVC = RSKImageCropViewController(image: captureImage!, cropMode: .square)
        imageCropVC.moveAndScaleLabel.text = "切り取り範囲を選択"
        imageCropVC.cancelButton.setTitle("キャンセル", for: .normal)
        imageCropVC.chooseButton.setTitle("完了", for: .normal)
        imageCropVC.delegate = self
        present(imageCropVC, animated: true)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue,sender: Any?){
        //次の画面のインスタンスを格納
        if let nextViewController = segue.destination as? SecondViewController{
            //次の画面のインスタンスに取得した画像を渡す
            nextViewController.captureImage = captureImage
        }
    }
    //キャンセルを押した時の処理
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    //完了を押した後の処理
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        //(3)モーダルビューを閉じる
        dismiss(animated: true, completion: {
            self.captureImage = croppedImage
            //エフェクト画面に遷移
            self.performSegue(withIdentifier: "toNextView", sender: nil)

        })
    }


}

