import UIKit

// MARK: - MovieQuizViewController
final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    // MARK: - Properties
    private var alertPresenter: AlertPresenterProtocol?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Outlets
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet weak private var counterLabel: UILabel!
    @IBOutlet weak private var noButton: UIButton!
    @IBOutlet weak private var yesButton: UIButton!
    @IBOutlet weak private var loadingActivityIndicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter = MovieQuizPresenter(viewController: self)
        loadingActivityIndicator.hidesWhenStopped = true
        alertPresenter = AlertPresenter(delegate: self)
    }
    
    // MARK: - Helper Methods
    func showLoadingIndicator() {
        loadingActivityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingActivityIndicator.stopAnimating()
    }
    
    func showQuestion(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
    }
    
    func showResult(quiz result: QuizResultsViewModel) {
        alertPresenter?.showAlert(alert: AlertModel(title: result.title, message: result.text, buttonText: result.buttonText, completion: {
            self.presenter?.restartGame()
        }))
    }
    
    func showAnswerResult(isCorrect: Bool) {
        let borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = borderColor
        imageView.layer.cornerRadius = 20
    }
    
    func showNextQuestionOrResults() {
        self.presenter.showNextQuestionOrResults()
    }
    
    func resetImageViewBorder() {
        imageView.layer.borderWidth = 0
    }
    
    func toggleButtonsActivity() {
        noButton.isEnabled.toggle()
        yesButton.isEnabled.toggle()
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator()
        
        alertPresenter?.showAlert(alert: AlertModel(title: "Ошибка", message: message, buttonText: "Попробовать еще раз", completion: { [weak self] in
            guard let self else {
                return
            }
            
            self.presenter.restartGame()
            self.presenter.questionFactory?.loadData()
            self.showLoadingIndicator()
        }))
    }
    
    // MARK: - Actions
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
}
