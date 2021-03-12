//
//  ContentView.swift
//  CameraSwiftUI
//
//  Created by Joshua Wilkinson on 2021-03-08.
//

import SwiftUI
import AVFoundation

@available(iOS 14.0, *)
struct ContentView: View {
  var body: some View {
    CameraView()
    }
}


@available(iOS 14.0, *)
struct CameraView: View {
  @StateObject var camera = CameraModel()
    var body: some View{
        ZStack{
            CameraPreview(camera: camera)
                .ignoresSafeArea(.all, edges:.all)
            
            VStack{
                if camera.isTaken{
                HStack{
                    Spacer()
                    
                    Button(action: camera.reTake, label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.white)
                                .clipShape(Circle())
                        })
                        .padding(.trailing,10)
                        
                        
                    
                }
            }
                Spacer()
                
                HStack{
                    if camera.isTaken{
                        Button(action: {if !camera.isSaved{camera.savePic()}}, label: {
                            Text(camera.isSaved ? "Saved" : "Save")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .clipShape(Capsule())
                        })
                        .padding(.leading)
                        
                        Spacer()
                    }
                    else{
                        Button(action: camera.takePic, label: {
                            ZStack{
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 65, height: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth:2)
                                    .frame(width: 75, height: 75)
                            }
                        })
                    }
                }.frame(height: 75)
            }
        }.onAppear(perform: {
            camera.Check()
        })
        .alert(isPresented: $camera.alert) {
          Alert(title: Text("Please enable camera access"))
        }
}
}

@available(iOS 13.0, *)
class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var output = AVCapturePhotoOutput()
    
    @Published var preview: AVCaptureVideoPreviewLayer!
    
    @Published var isSaved = false
    
    @Published var picData = Data(count:0)
    
    func Check(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (status) in
                
                if status {
                    self.setUp()
                }
            })
            
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp() {
        do{
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
            let input = try AVCaptureDeviceInput(device: device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if (self.session.canAddOutput(self.output)){
                self.session.addOutput(self.output)
            }
            
            self.session.commitConfiguration()
            
        }
        catch{
            print(error.localizedDescription)
        }
    }
    
    func takePic() {
        self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
            }
        }
    }
    
    func reTake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            DispatchQueue.main.async {
                withAnimation{self.isTaken.toggle()}
                self.isSaved = false
                self.picData = Data(count: 0)
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        if error != nil{
            return
        }
        
        print ("pic taken...")
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        self.picData = imageData
        
    }
    
    func savePic() {
      guard let image = UIImage(data: self.picData) else{return}
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.isSaved = true
        print("saved successfully !")
    }
    
    
}

@available(iOS 13.0, *)
struct CameraPreview: UIViewRepresentable {
    @ObservedObject var camera : CameraModel
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        camera.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(camera.preview)
        
        camera.session.startRunning()
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
