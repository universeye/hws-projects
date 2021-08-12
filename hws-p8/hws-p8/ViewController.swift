//
//  ViewController.swift
//  hws-p8
//
//  Created by Terry Kuo on 2021/7/21.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    var cluesLabel = p8Label(numberOfLines: 7)
    var answersLabel = p8Label(numberOfLines: 0, textAlignment: .right)
    var scoreLabel = p8Label(numberOfLines: 1, textAlignment: .right)
    
    
    var currentAnswer: UITextField = {
        let currentTextField = UITextField()
        currentTextField.translatesAutoresizingMaskIntoConstraints = false
        currentTextField.placeholder = "Tap letters to guess"
        currentTextField.font = UIFont.systemFont(ofSize: 44)
        currentTextField.isUserInteractionEnabled = false
        return currentTextField
    }()
    
    let buttonsContainerView: UIView = {
        let bCV = UIView()
        bCV.translatesAutoresizingMaskIntoConstraints = false
        return bCV
    }()
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    var level = 1
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    lazy var submitButton = p8Button(title: "SUBMIT")
    lazy var clearButton = p8Button(title: "CLEAR")
    
    private let width = 150
    private let height = 80
    
    
    //MARK: - APP LifeCycle
    
    
    override func loadView() {
        view = UIView()
        
        configureView()
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                buttonsContainerView.addSubview(letterButton)
                letterButtons.append(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped(_:)), for: .touchUpInside)
            }
        }
        
        submitButton.addTarget(self, action: #selector(submitTapped(_:)), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "Score: \(score)"
        loadLevel()
    }
    
    //MARK: - Functions
    
    private func configureView() {
        view.backgroundColor = .white
        
        view.addSubview(scoreLabel)
        view.addSubview(cluesLabel)
        view.addSubview(answersLabel)
        view.addSubview(currentAnswer)
        
        view.addSubview(submitButton)
        view.addSubview(clearButton)
        view.addSubview(buttonsContainerView)
        
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: 0),
            
            // pin the top of the clues label to the bottom of the score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            
            // make the clues label 60% of the width of our layout margins, minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            // also pin the top of the answers label to the bottom of the score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            
            // make the answers label stick to the trailing edge of our layout margins, minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            
            // make the answers label take up 40% of the available space, minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            
            // make the answers label match the height of the clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            
            
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            
            
            submitButton.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 20),
            submitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submitButton.heightAnchor.constraint(equalToConstant: 44),
            submitButton.widthAnchor.constraint(equalToConstant: 70),
            
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clearButton.centerYAnchor.constraint(equalTo: submitButton.centerYAnchor),
            clearButton.heightAnchor.constraint(equalToConstant: 44),
            clearButton.widthAnchor.constraint(equalToConstant: 70),
            
            buttonsContainerView.widthAnchor.constraint(equalToConstant: 750),
            buttonsContainerView.heightAnchor.constraint(equalToConstant: 320),
            buttonsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsContainerView.topAnchor.constraint(equalTo: submitButton.bottomAnchor, constant: 20),
            buttonsContainerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    
    private func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let letterFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: letterFileURL) {
                print(("levelContents: \(levelContents)"))
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                print("lines: \(lines)")
                
                for (index, line) in lines.enumerated() {
                    print("=======================================")
                    print("\(line) in \(index)")
                    let parts = line.components(separatedBy: ": ")
                    print("parts: \(parts)")
                    let answer = parts[0]
                    let clue = parts[1]
                    print("so the answer is \(answer)")
                    print("so the clue is \(clue)")
                    
                    clueString += "\(index + 1). \(clue)\n"
                    print("clueString = \(clueString)")
                    let solutuionWord = answer.replacingOccurrences(of: "|", with: "")
                    print("solutionWord = \(solutuionWord)")
                    solutionString += "\(solutuionWord.count) letters\n"
                    print("solutionString = \(solutionString)")
                    solutions.append(solutuionWord)
                    let bits = answer.components(separatedBy: "|")
                    print("bits: \(bits)")
                    letterBits += bits
                    print("letterBits = \(letterBits)")
                }
            }
        }
        
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == letterButtons.count {
            for i in 0..<letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    private func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)
        loadLevel()
        
        for btn in letterButtons {
            btn.isHidden = false
        }
        
    }
    
    
    //MARK: - Button Tapped
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else {
            return
        }
        
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        sender.isHidden = true
        activatedButtons.append(sender)
        print("activatedButton currently contains \(activatedButtons)")
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        
        guard let answerText = currentAnswer.text else {
            return
        }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            print("splitAnswers is \(splitAnswers ?? ["no answers"])")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            currentAnswer.text = ""
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Congrats!", message: "You win!", preferredStyle: .alert)
                
                ac.addAction(UIAlertAction(title: "Let's Go", style: .default, handler: levelUp))
                present(ac, animated: true, completion: nil)
            }
        } else {
            let ac = UIAlertController(title: "Wrong!", message: "wrong word, try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Try Again", style: .default, handler: clearTapped))
            present(ac, animated: true, completion: nil)
        }
    }
    
    @objc func clearTapped(action: UIAlertAction?) {
        currentAnswer.text = ""
        for btn in activatedButtons {
            btn.isHidden = false
        }
        activatedButtons.removeAll()
    }
    
    
    
}

