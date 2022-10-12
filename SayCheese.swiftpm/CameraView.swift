

import SwiftUI
import UIKit
import AVFoundation

struct CameraView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var name: String?
    @State private var isPresented = false
    @ObservedObject var viewModel = CameraViewModel()
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage()
    
    var body: some View {
        ZStack{
            VStack {
                HStack {
                    Button(action: {viewModel.switchSilent()}) {
                        Image(viewModel.isSilentModeOn ? "sound_off" : "sound_on")
                        .resizable()
                        .frame(width: 60, height: 60)
                    }
                    .padding(.horizontal, 30)
                    
                    Button(action: {viewModel.switchFlash()}) {
                        Image(viewModel.isFlashOn ? "light_on" : "light_off")
                        .resizable()
                        .frame(width: 50, height: 50)
                    }
                    .padding(.horizontal, 30)
                }
                .font(.system(size:25))
                .padding()
                
                Spacer()
                
                Text(speechRecognizer.transcript)
                    .onChange(of: speechRecognizer.transcript) { newValue in
                        print("\(Text(speechRecognizer.transcript))")
                        isRecording = true
                   
                        if (speechRecognizer.transcript.range(of: "Say cheese", options: .regularExpression) != nil)
                        {
                            print("Cheese")
                            viewModel.capturePhoto();speechRecognizer.reset();print("reset");speechRecognizer.transcribe();print("tran")
                        }
                        
                        if (speechRecognizer.transcript.range(of: "say cheese", options: .regularExpression) != nil)
                        {
                            print("cheese")
                            viewModel.capturePhoto();speechRecognizer.reset();print("reset");speechRecognizer.transcribe();print("tran")
                        }
                        
                        
                        if (speechRecognizer.transcript.range(of: "Facing camera", options: .backwards) != nil) && viewModel.isFacingModeOn == false
                        {
                            print("Front camera, changeCamera")
                            viewModel.switchCamera();speechRecognizer.reset();print("reset2");speechRecognizer.transcribe();print("tran2");
                           
                        }
                        
                        if (speechRecognizer.transcript.range(of: "facing camera", options: .backwards) != nil) && viewModel.isFacingModeOn == false
                        {
                            print("Front camera, changeCamera")
                            viewModel.switchCamera();speechRecognizer.reset();print("reset2");speechRecognizer.transcribe();print("tran2");
                            
                        }
                        
                        if (speechRecognizer.transcript.range(of: "main camera", options: .backwards) != nil) && viewModel.isFacingModeOn == true
                        {
                            print("Back camera, changeCamera")
                            viewModel.switchCamera();speechRecognizer.reset();print("reset2");speechRecognizer.transcribe();print("tran2");
                        }
                        
                        if (speechRecognizer.transcript.range(of: "Main camera", options: .backwards) != nil) && viewModel.isFacingModeOn == true
                        {
                            print("back camera, changeCamera")
                            viewModel.switchCamera();speechRecognizer.reset();print("reset2");speechRecognizer.transcribe();print("tran2");
                        }
                    
                        if (speechRecognizer.transcript.range(of: "Be quiet", options: .backwards) != nil) && viewModel.isSilentModeOn == false
                        {
                            viewModel.switchSilent()
                            print("Be quiet, isSilentModeOn = true")
                        }
                        
                        if (speechRecognizer.transcript.range(of: "be quiet", options: .backwards) != nil) && viewModel.isSilentModeOn == false
                        {
                            print("silent mode, isSilentModeOn = true")
                            viewModel.switchSilent()
                        }
                        
                        if (speechRecognizer.transcript.range(of: "sound mode", options: .backwards) != nil) && viewModel.isSilentModeOn == true
                        {
                            viewModel.switchSilent()
                            print("sound mode, isSilentModeOn = false")
                        }
                        
                        if  (speechRecognizer.transcript.range(of: "Sound mode", options: .backwards) != nil) && viewModel.isSilentModeOn == true
                        {
                            viewModel.switchSilent()
                            print("sound mode, isSilentModeOn = false")
                        }
                        
                        if (speechRecognizer.transcript.range(of: "Flash on", options: .backwards) != nil) && viewModel.isFlashOn == false
                        {
                            viewModel.switchFlash()
                            print("Flash on, isFlashOn = true")
                        }
                        
                        if (speechRecognizer.transcript.range(of: "flash on", options: .backwards) != nil) && viewModel.isFlashOn == false
                        {
                            viewModel.switchFlash()
                            print("flash on, isFlashOn = true")
                        }
                        
                        if (speechRecognizer.transcript.range(of: "Flash off", options: .backwards) != nil) && viewModel.isFlashOn == true
                        {
                            viewModel.switchFlash()
                            print("Flash off, isFlashOn = false")
                        }
                        
                        if (speechRecognizer.transcript.range(of: "Flashlight off", options: .backwards) != nil) && viewModel.isFlashOn == true
                        {
                            viewModel.switchFlash()
                            print("Flash off, isFlashOn = false")
                        }
                        
                        if (speechRecognizer.transcript.range(of: "flashlight off", options: .backwards) != nil) && viewModel.isFlashOn == true
                        {
                            viewModel.switchFlash()
                            print("Flash off, isFlashOn = false")
                        }
                        
                        if (speechRecognizer.transcript.range(of: "flash off", options: .backwards) != nil) && viewModel.isFlashOn == true
                        {
                            viewModel.switchFlash()
                            print("flash off, isFlashOn = false")
                        }
                    }
                
                
                viewModel.cameraPreview.ignoresSafeArea()
                    .frame(width: 390, height: 480)
                    .onAppear {
                        viewModel.configure()
                    }
    
                    .gesture(MagnificationGesture()
                        .onChanged { val in
                            viewModel.zoom(factor: val)
                        }
                        .onEnded { _ in
                            viewModel.zoomInitialize()
                        }
                    )
                
                HStack{
                    Button(action: {self.isShowPhotoLibrary = true}) {
                        if let previewImage = viewModel.recentImage {
                            Image(uiImage: previewImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 75, height: 75)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .aspectRatio(1, contentMode: .fit)
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                                .foregroundColor(.yellow)
                                .frame(width: 75, height: 75)
                        }
                    }
                    Spacer(minLength: 60)
                    
                    Button(action: {viewModel.capturePhoto();speechRecognizer.reset();print("reset2");speechRecognizer.transcribe();print("tran2");}) {
                        Image("camera_button")
                            .resizable()
                            .frame(width: 90, height: 90)
                    }
                    
                    Spacer()
                    
                    Button(action: {viewModel.switchCamera();speechRecognizer.reset();print("reset2");speechRecognizer.transcribe();print("tran2");}) {
                        Image("CameraChange")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        
                    }
                    .frame(width: 75, height: 75)
                    .padding()
                }
            }
            .foregroundColor(.black)
            .opacity(viewModel.shutterEffect ? 0 : 1)
        }     .padding()
            .foregroundColor(.blue)
            .onAppear {
                speechRecognizer.reset()
                speechRecognizer.transcribe()
                print("reset tran start")
                scrumTimer.startScrum()
            }
            .sheet(isPresented: $isShowPhotoLibrary) {
                ImagePicker(sourceType: .photoLibrary)
            }
    }
}


struct CameraPreviewView: UIViewRepresentable {
    class VideoPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }
    
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> VideoPreviewView {
        let view = VideoPreviewView()
        
        view.videoPreviewLayer.session = session
        view.backgroundColor = .black
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        view.videoPreviewLayer.cornerRadius = 0
        view.videoPreviewLayer.connection?.videoOrientation = .portrait
        
        return view
    }
    
    func updateUIView(_ uiView: VideoPreviewView, context: Context) {
        
    }
    
    
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView(name: .constant(nil), scrum: .constant(DailyScrum.sampleData[0]))
    }
}


struct ImagePicker: UIViewControllerRepresentable {
 
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
 
    }
}
