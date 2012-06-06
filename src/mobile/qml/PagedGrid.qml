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

Item {
    id: pagedGrid

    // Read/write properties.
//    property QtObject model: null
//    property Component delegate: null
    property alias model: gridView.model
    property alias delegate: gridView.delegate
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
    property alias pageCount: gridView.pageCount

    width: pagedGrid.pageWidth + 2 * extraMargin
    height: pagedGrid.pageHeight
    clip: true

    // x and y will be given in coordinates relative to the clicked item.
    signal itemClicked(int index, int x, int y);

    function itemAt(index) {
        return null//gridView.itemAt(index)
    }

    property int guidesOpacity: 0

    GridView {
        id: gridView
        property int pageCount: model ? Math.ceil(gridView.count / itemsPerPage) : 0
        model: pagedGrid.model
        delegate: pagedGrid.delegate
        cellHeight: pagedGrid.itemHeight + pagedGrid.spacing
        cellWidth: pagedGrid.itemWidth + pagedGrid.spacing
        height: 2 * cellHeight
        width: 2 * cellWidth

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            leftMargin: 40
            //rightMargin: 40
        }

        onPageCountChanged: console.log('gridView.pageCount: ' + pageCount)

        footer: Rectangle {
            height: pagedGrid.itemHeight
            width: pagedGrid.itemWidth
            color: 'red'
            opacity: 0.3
        }

        highlightFollowsCurrentItem: true
        highlight: Component {
            Rectangle {
                width: gridView.cellWidth; height: gridView.cellHeight
                color: "lightsteelblue"; radius: 5
                x: gridView.currentItem.x
                y: gridView.currentItem.y
                Behavior on x { SpringAnimation { spring: 3; damping: 0.2 } }
                Behavior on y { SpringAnimation { spring: 3; damping: 0.2 } }
            }
        }

        flow: GridView.TopToBottom
        interactive: true
        /*SwipeArea {
            id: swipeArea
            anchors.fill: parent
            z: 1

            onClicked: {
                console.log('clicked!')
                var x = mouse.x
                var y = mouse.y
                var index = gridView.indexAt(x, y)
                var foo = mapFromItem(gridView, x, y)
                console.log('mapFromItem:' + foo)
                var bar = mapToItem(gridView, x, y)
                console.log('mapToItem:' + bar)
                console.log(gridView.currentItem.x, gridView.currentItem.width)
                console.log('indexAt(' + x + ', ' + y + '): ' + index)
            }

            onSwipeLeft: {
                console.log('swipe left!')
                if (gridView.currentIndex + 4 > gridView.count)
                    return;
                gridView.currentIndex += 4
                gridView.positionViewAtIndex(gridView.currentIndex, GridView.Beginning)
            }

            onSwipeRight: {
                console.log('swipe right!')
                if (gridView.currentIndex === 0)
                    return;
                gridView.currentIndex -= 4
                gridView.positionViewAtIndex(gridView.currentIndex, GridView.Beginning)
            }
        }*/
    }

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
