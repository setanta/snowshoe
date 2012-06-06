/****************************************************************************
 *   Copyright (C) 2012  Instituto Nokia de Tecnologia (INdT)               *
 *                                                                          *
 *   This file may be used under the terms of the GNU Lesser                *
 *   General Public License version 2.1 as published by the Free Software   *
 *   Foundation and appearing in the file LICENSE.LGPL included in the      *
 *   packaging of this file.  Please review the following information to    *
 *   ensure the GNU Lesser General Public License version 2.1 requirements  *
 *   will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.   *
 *                                                                          *
 *   This program is distributed in the hope that it will be useful,        *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the          *
 *   GNU Lesser General Public License for more details.                    *
 ****************************************************************************/

import QtQuick 2.0
import Snowshoe 1.0

GridView {
    id: pagedGrid

    // Read/write properties.
//    property QtObject model: null
//    property Component delegate: null
    //property alias model: gridView.model
    //property alias delegate: gridView.delegate
    property Component emptyItemDelegate: null
    property int extraMargin: 40
    property int itemWidth: 192
    property int itemHeight: 263

    property int rowsPerPage: 2
    property int columnsPerPage: 2
    property int spacing: 16
    property int currentPage: 0
    property int maxPages: 1

    // Read only properties.
    property int page: 0
    property int pageWidth: columnsPerPage * itemWidth + (columnsPerPage - 1) * spacing
    property int pageHeight: rowsPerPage * itemHeight + (rowsPerPage - 1) * spacing
    property int itemsPerPage: rowsPerPage * columnsPerPage
    //property alias pageCount: gridView.pageCount

    width: pagedGrid.pageWidth + 2 * extraMargin
    height: pagedGrid.pageHeight
    clip: false

    // x and y will be given in coordinates relative to the clicked item.
    signal itemClicked(int index, int x, int y);

    function itemAt(index) {
        return null//gridView.itemAt(index)
    }

    //boundsBehavior: Flickable.StopAtBounds
    //GridView {
        //id: gridView
        property int pageCount: model ? Math.ceil(pagedGrid.count / itemsPerPage) : 0
        //model: pagedGrid.model
        delegate: pagedGrid.delegate
        cellHeight: pagedGrid.itemHeight + pagedGrid.spacing
        cellWidth: pagedGrid.itemWidth + pagedGrid.spacing
        //height: 2 * cellHeight
        //width: 2 * cellWidth

        contentHeight: height
        contentWidth: width * pageCount


        /*anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 40
            //rightMargin: 40
        }*/
        anchors.leftMargin: 40
        anchors.rightMargin: 40

        onPageCountChanged: console.log('pagedGrid.pageCount: ' + pageCount)

        footer: Rectangle {
            height: pagedGrid.itemHeight
            width: pagedGrid.itemWidth
            color: 'red'
            opacity: 0.3
        }

        highlightFollowsCurrentItem: true
        highlight: Component {
            Rectangle {
                width: pagedGrid.cellWidth; height: pagedGrid.cellHeight
                color: "lightsteelblue"; radius: 5
                x: pagedGrid.currentItem.x
                y: pagedGrid.currentItem.y
                Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }
            }
        }

        flow: GridView.TopToBottom
        interactive: false
        SwipeArea {
            id: swipeArea
            anchors.fill: parent
            z: 1

            onClicked: {
                console.log('clicked!')
                var x = mouse.x
                var y = mouse.y
                var index = pagedGrid.indexAt(x, y)
                var foo = mapFromItem(pagedGrid, x, y)
                console.log('mapFromItem:' + foo)
                var bar = mapToItem(pagedGrid, x, y)
                console.log('mapToItem:' + bar)
                console.log(pagedGrid.currentItem.x, pagedGrid.currentItem.width)
                console.log('indexAt(' + x + ', ' + y + '): ' + index)
            }

            onSwipeLeft: {
                console.log('swipe left!')
                if (pagedGrid.currentIndex + 4 > pagedGrid.count)
                    return;
                pagedGrid.currentIndex += 4
                pagedGrid.positionViewAtIndex(pagedGrid.currentIndex, GridView.Beginning)
            }

            onSwipeRight: {
                console.log('swipe right!')
                if (pagedGrid.currentIndex === 0)
                    return;
                pagedGrid.currentIndex -= 4
                pagedGrid.positionViewAtIndex(pagedGrid.currentIndex, GridView.Beginning)
            }
        }
    //}

    property int guidesOpacity: 0
    Rectangle {
        color: 'yellow'
        opacity: guidesOpacity
        anchors.fill: parent
    }


    /*
    onPageCountChanged: {
        if (pageCount === currentPage && currentPage > 0)
            --currentPage;
    }

    PageFillGrid {
        id: grid
        model: pagedGrid.model
        delegate: pagedGrid.delegate
        spacing: pagedGrid.spacing
        itemWidth: pagedGrid.itemWidth
        itemHeight: pagedGrid.itemHeight
        rowsPerPage: pagedGrid.rowsPerPage
        columnsPerPage: pagedGrid.columnsPerPage
        maxPages: pagedGrid.maxPages
        emptyItemDelegate: pagedGrid.emptyItemDelegate
        x: extraMargin - currentPage * (pageWidth + pagedGrid.spacing)

        Behavior on x {
            NumberAnimation { duration: 100 }
        }
    }
    */
    /*
    SwipeArea {
        id: swipeArea
        anchors.fill: parent
        z: 1

        onClicked: {
            // Track down which item has been pressed on current page.
            var x = mouse.x - extraMargin;
            var y = mouse.y;
            if (!pageCount || x < 0 || x >= grid.pageWidth)
                return;

            var row = Math.floor(y / (itemHeight + spacing)), column = Math.floor(x / (itemWidth + spacing));
            var topLeftX = (itemWidth + spacing) * column, topLeftY = (itemHeight + spacing) * row;
            var bottomRightX = topLeftX + itemWidth, bottomRightY = topLeftY + itemHeight;
            if (x >= topLeftX && x <= bottomRightX && y >= topLeftY && y <= bottomRightY) {
                var itemIndex = currentPage * grid.itemsPerPage + row * columnsPerPage + column
                var item = grid.itemAt(itemIndex)
                if (item !== null) {
                    // Emit a signal pointing the item clicked and the internal position of the click.
                    pagedGrid.itemClicked(itemIndex, x - topLeftX, y - topLeftY);
                }
            }
        }

        onSwipeLeft: {
            console.log('swipe left!')
            grid.positionViewAtIndex(4, GridView.Beginning)
//            if (currentPage < pageCount - 1)
//                ++currentPage;
        }

        onSwipeRight: {
            grid.positionViewAtIndex(0, GridView.Beginning)
            console.log('swipe right!')
//            if (currentPage > 0)
//                --currentPage;
        }
    }
*/
}
