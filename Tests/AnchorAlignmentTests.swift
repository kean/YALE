// The MIT License (MIT)
//
// Copyright (c) 2017 Alexander Grebenyuk (github.com/kean).

import XCTest
import Yalta


/// Everything that applies for both edges and center
class AnchorAlignmentTests: XCTestCase {
    let container = UIView()
    let view = UIView()

    override func setUp() {
        super.setUp()

        container.addSubview(view)
    }

    // MARK: Alignments

    func testTopAlignWith() {
        test("align top with the same edge") {
            let c = view.al.top.align(with: container.al.top)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top))
        }

        test("align top with the other edge") {
            let c = view.al.top.align(with: container.al.bottom)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .bottom))
        }

        test("align top with the center") {
            let c = view.al.top.align(with: container.al.centerY)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .centerY))
        }

        test("align top with offset, relation, multiplier") {
            let c = view.al.top.align(with: container.al.top, offset: 10, multiplier: 2, relation: .greaterThanOrEqual)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(
                item: view,
                attribute: .top,
                relation: .greaterThanOrEqual,
                toItem: container,
                attribute: .top,
                multiplier: 2,
                constant: 10
            ))
        }
    }

    func testAlignDifferentAnchors() {
        test("align bottom") {
            let c = view.al.bottom.align(with: container.al.bottom)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .bottom, toItem: container, attribute: .bottom))
        }

        test("align leading") {
            let c = view.al.leading.align(with: container.al.leading)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .leading, toItem: container, attribute: .leading))
        }

        test("align trailing") {
            let c = view.al.trailing.align(with: container.al.trailing)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .trailing, toItem: container, attribute: .trailing))
        }

        test("align left with left") {
            let c = view.al.left.align(with: container.al.left)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .left, toItem: container, attribute: .left))
        }

        test("align right with left") {
            let c = view.al.right.align(with: container.al.left)
            XCTAssertEqualConstraints(c, NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .left))
        }

        test("align firstBaseline with firstBaseline") {
            XCTAssertEqualConstraints(
                view.al.firstBaseline.align(with: container.al.firstBaseline),
                NSLayoutConstraint(item: view, attribute: .firstBaseline, toItem: container, attribute: .firstBaseline)
            )
        }

        test("align lastBaseline with top") {
            XCTAssertEqualConstraints(
                view.al.lastBaseline.align(with: container.al.top),
                NSLayoutConstraint(item: view, attribute: .lastBaseline, toItem: container, attribute: .top)
            )
        }
    }

    // MARK: Offsetting

    func testOffsettingTopAnchor() {
        let anchor = container.al.top.offsetting(by: 10)
        XCTAssertEqualConstraints(
            view.al.top.align(with: anchor),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.al.top.align(with: anchor, offset: 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 20)
        )
        XCTAssertEqualConstraints( // test that works both ways
            anchor.align(with: view.al.top),
            NSLayoutConstraint(item: container, attribute: .top, toItem: view, attribute: .top, constant: -10)
        )
    }

    func testOffsettingUsingOperators() {
        XCTAssertEqualConstraints(
            view.al.top.align(with: container.al.top + 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 10)
        )
        XCTAssertEqualConstraints(
            view.al.top.align(with: container.al.top - 10),
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: -10)
        )
    }

    func testOffsettingRightAnchor() {
        let anchor = container.al.right.offsetting(by: -10)
        XCTAssertEqualConstraints(
            view.al.right.align(with: anchor),
            NSLayoutConstraint(item: view, attribute: .right, toItem: container, attribute: .right, constant: -10)
        )
        XCTAssertEqualConstraints( // test that works both ways
            anchor.align(with: view.al.right),
            NSLayoutConstraint(item: container, attribute: .right, toItem: view, attribute: .right, constant: 10)
        )
    }

    func testAligningTwoOffsetAnchors() {
        let containerTop = container.al.top.offsetting(by: 10)
        let viewTop = view.al.top.offsetting(by: 10)
        XCTAssertEqualConstraints(
            viewTop.align(with: containerTop), // nobody's going to do that, but it's nice it's their
            NSLayoutConstraint(item: view, attribute: .top, toItem: container, attribute: .top, constant: 0)
        )
    }
}
