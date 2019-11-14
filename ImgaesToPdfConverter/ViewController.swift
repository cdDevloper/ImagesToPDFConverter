//
//  ViewController.swift
//  ImgaesToPdfConverter
//
//  Created by Chaitanya Patil on 14/11/19.
//  Copyright © 2019 SiteFuelUSA. All rights reserved.
//

import UIKit
import PDFGenerator


class ViewController: UIViewController {
    var imagePicker: ImagePicker!
    var arrimages = [UIImage]()
    fileprivate var outputAsData: Bool = false
    
    fileprivate func getImagePath(_ number: Int) -> String {
        return Bundle.main.path(forResource: "sample_\(number)", ofType: "jpg")!
    }
    
    fileprivate func getDestinationPath(pdfData:Data,pdfNameFromUrl:String) -> String {
       // DispatchQueue.main.async {
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData.write(to: actualPath, options: .atomic)
                 print("pdf successfully saved!")
                return actualPath.path
            } catch {
                print("Pdf could not be saved")
            }
       // }
        return ""
    }
    override func viewDidLoad() {
        super.viewDidLoad()
          self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
    }

    @IBAction func btnclick(_ sender: UIButton) {
         self.imagePicker.present(from: sender)
    }
    
    @IBAction func generateSamplePDFFromImages(_ sender: UIButton){
        var pages = [PDFPage]()
        for image in arrimages{
            pages.append(PDFPage.image(image))
        }
            do {
                let data = try PDFGenerator.generated(by: pages, dpi: .default)
                let str = data.base64EncodedString()
                openPDFViewer(getDestinationPath(pdfData: data, pdfNameFromUrl: "bol.pdf"))
            } catch let e {
                print(e)
        }
    }
    
    fileprivate func openPDFViewer(_ pdfPath: String) {
        self.performSegue(withIdentifier: "PreviewVC", sender: pdfPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pdfPreviewVC = segue.destination as? PDFPreviewVC, let pdfPath = sender as? String {
            let url = URL(fileURLWithPath: pdfPath)
            pdfPreviewVC.setupWithURL(url)
        }
    }
}


extension ViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        if image != nil{
            arrimages.append(image!)
        }
    }
}

