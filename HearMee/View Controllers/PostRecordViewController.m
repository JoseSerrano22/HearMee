//
//  PostRecordViewController.m
//  HearMee
//
//  Created by jose1009 on 7/30/21.
//

#import "PostRecordViewController.h"
#import "FeedViewController.h"
#import "UIImage+Extension.h"
#import "Post.h"

@interface PostRecordViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *const postImage;
@property (weak, nonatomic) IBOutlet UITextView *const captionTextView;

@end

@implementation PostRecordViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.captionTextView.delegate = self;
    self.postImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *const tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(_tapImageGesture:)];
    tapGesture1.numberOfTapsRequired = 1;
    [self.postImage addGestureRecognizer:tapGesture1];
}

#pragma mark - Private

- (IBAction)_backDidTap:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)_shareDidTap:(id)sender {
    
    UIImage *const resizeImage = [UIImage _resizeImage:self.postImage.image withSize:(CGSizeMake(400, 400))];
    [Post postUserAudio:self.audioFile withFilter:self.filterName withImage:resizeImage withCaption:self.captionTextView.text withCompletion:nil];
    [self.view.window.rootViewController dismissViewControllerAnimated:true completion:nil];
}

- (void)_tapImageGesture: (id)sender {
    UIImagePickerController *const imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    UIAlertController *const usernameAlert = [UIAlertController alertControllerWithTitle:@"Choose"
                                                                                 message:@""
                                                                          preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *const takePhotoAction = [UIAlertAction actionWithTitle:@"Take Photo"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * _Nonnull action) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else {
            NSLog(@"Camera 🚫 available so we will use photo library instead");
            imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    [usernameAlert addAction:takePhotoAction];
    
    UIAlertAction *const cameraRollAction = [UIAlertAction actionWithTitle:@"Camera Roll"
                                                                     style:UIAlertActionStyleDefault
                                                                   handler:^(UIAlertAction * _Nonnull action) {
        
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePickerVC animated:YES completion:nil];
    }];
    [usernameAlert addAction:cameraRollAction];
    
    [self presentViewController:usernameAlert animated:YES completion:^{
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *const editedImage = info[UIImagePickerControllerEditedImage];
    self.postImage.image = editedImage;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"Write a caption..."]){
        textView.text = @"";
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write a caption...";
    }
    [textView resignFirstResponder];
}

@end
