//
//  ViewController.swift
//  uploadImage
//
//  Created by jincon on 15/12/1.
//  Copyright © 2015年 jincon. All rights reserved.
//

import UIKit

class ViewController: UIViewController , UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func fromAlbum(sender: AnyObject) {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //设置是否允许编辑
            //picker.allowsEditing = editSwitch.on
            //弹出控制器，显示界面
            self.presentViewController(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
        
        
    }
    
    //选择图片成功后代理
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            //查看info对象
            print(info)
            //获取选择的原图
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            imageView.image = image
            let midImage:UIImage=self.imageWithImageSimple(image,scaledToSize:CGSizeMake(800.0,800.0))
            
            upload(midImage)
            //图片控制器退出
            picker.dismissViewControllerAnimated(true, completion: {
                () -> Void in
            })
    }
    
    //图片等比例压缩
    func imageWithImageSimple(image:UIImage,scaledToSize newSize:CGSize)->UIImage
    {
        var width:CGFloat!
        var height:CGFloat!
        //等比例缩放
        if image.size.width/newSize.width >= image.size.height / newSize.height{
            width = newSize.width
            height = image.size.height / (image.size.width/newSize.width)
        }else{
            height = newSize.height
            width = image.size.width / (image.size.height/newSize.height)
        }
        let sizeImageSmall = CGSizeMake(width, height)
        //end
        print(sizeImageSmall)
        
        UIGraphicsBeginImageContext(sizeImageSmall);
        image.drawInRect(CGRectMake(0,0,sizeImageSmall.width,sizeImageSmall.height))
        let newImage:UIImage=UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
    func upload(img:UIImage)
        
    {
        
        
        
//        lb.frame=CGRectMake(0,0, self.view.bounds.size.width,20)
//        lb.textColor=UIColor.whiteColor()
//        lb.text="上传中...."
//        lb.textAlignment=NSTextAlignment.Center
//        lb.backgroundColor=UIColor.blackColor()
//        lb.alpha=1
        
        
        //添加风火轮
        let av = UIActivityIndicatorView()
        av.frame=CGRectMake(200,200,20, 20)
        av.backgroundColor=UIColor.whiteColor()
        av.color=UIColor.redColor()
        av.startAnimating()
        self.view.addSubview(av)
        
        //self.view.addSubview(lb)
        
        let data=UIImagePNGRepresentation(img)//把图片转成data
        let uploadurl:String="http://xxxx/upload.php"//设置服务器接收地址
        let request=NSMutableURLRequest(URL:NSURL(string:uploadurl)!)
        request.HTTPMethod="POST"//设置请求方式
        
        let boundary:String="-------------------21212222222222222222222"
        
        let contentType:String="multipart/form-data;boundary="+boundary
        
        request.addValue(contentType, forHTTPHeaderField:"Content-Type")
        
        let body=NSMutableData()
        
        body.appendData(NSString(format:"\r\n--\(boundary)\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(NSString(format:"Content-Disposition:form-data;name=\"userfile\";filename=\"dd.jpg\"\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(NSString(format:"Content-Type:application/octet-stream\r\n\r\n").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        body.appendData(data!)
        
        body.appendData(NSString(format:"\r\n--\(boundary)").dataUsingEncoding(NSUTF8StringEncoding)!)
        
        request.HTTPBody=body
        
        let que=NSOperationQueue()
        
        NSURLConnection.sendAsynchronousRequest(request, queue: que, completionHandler: {
            
            (response, data, error) ->Void in
            if (error != nil){
                print(error)
            }else{
                //Handle data in NSData type
                let tr:String=NSString(data:data!,encoding:NSUTF8StringEncoding)! as String
                print(tr)
                //在主线程中更新UI风火轮才停止
                
                dispatch_sync(dispatch_get_main_queue(), {
                    av.stopAnimating()
                    //self.lb.hidden=true
                })
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

