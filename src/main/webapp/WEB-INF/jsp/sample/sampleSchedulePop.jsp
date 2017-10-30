<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>


<!--

[참고]

- https://javascript.daypilot.org/open-source/
- https://code.daypilot.org/17910/html5-event-calendar-open-source


- https://doc.daypilot.org/calendar/jquery/
- https://java.daypilot.org/demo/Calendar/JQuery.jsp


[event data]

- https://api.daypilot.org/daypilot-event-data/


-->

<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/resources/css/calendar_white.css" />

<!-- js -->
<script type="text/javascript" src="<c:url value='${pageContext.request.contextPath}/resources/js/daypilot-all.min.js'/>"></script>
<!-- js -->



<div id="content_pop">
    <!-- 타이틀 -->
    <div id="title">
        <ul>
            <li>schedule sample</li>
        </ul>
    </div>

    <form id="searchForm" method="get" action="">
        Id : <input type="text" id="memoId" name="memoId">
    </form>

    <div style="float:left; width: 160px;">
        <div id="nav"></div>
    </div>
    <div style="margin-left: 160px;">
        <div id="dp"></div>
    </div>

    </table>
    <div id="main">
        <div id="divDetail">
            <form id="detailForm" method="post" action="">
                <input type="button" value="getInfo" onclick="fn_getInfo();"/>
                <input type="button" value="getIndex" onclick="fn_getIndex();"/>
                <input type="button" value="addInfo" onclick="fn_addInfo();"/>
                <input type="button" value="removeInfo" onclick="fn_removeInfo();"/>
            </form>
        </div>
    </div>
</div>






<script type="text/javaScript" language="javascript">

    var dp;

    $(document).ready(function () {

        var nav = new DayPilot.Navigator("nav");
        nav.showMonths = 1;
        nav.skipMonths = 1;
        nav.selectMode = "week";
        //nav.selectMode = "day";
        nav.init();


        nav.onTimeRangeSelected = function(args) {
            dp.startDate = args.day;
            dp.update();
        };

        dp = new DayPilot.Calendar("dp");
        dp.viewType = "Week";
//        dp.viewType = "Day";

        dp.events.list = [
            {
                "id":"5",
                "text":"Calendar Event 5",
                "start":"2017-10-30T10:30:00",
                "end":"2017-10-30T16:30:00"
            },
            {
                "id":"6",
                "text":"Calendar Event 6",
                "start":"2017-10-30T09:00:00",
                "end":"2017-10-30T14:30:00"
            },
            {
                "id":"7",
                "text":"Calendar Event 7",
                "start":"2017-10-30T12:00:00",
                "end":"2017-10-30T16:00:00"
            }];

        // event moving
        dp.onEventMoved = function (args) {
            var content = args.e.text();

            console.log(JSON.stringify(args));
            Common.alert(JSON.stringify(args));

            console.log("==== onEventMoved =====");
            console.log("args.newStart : " + args.newStart);
            console.log("args.newEnd : " + args.newEnd);
            console.log("args.e.data.id : " + args.e.data.id);
            console.log("content : " + content);
            console.log("==== onEventMoved =====");
        };

        // event resizing
        dp.onEventResized = function (args) {
            var content = args.e.text();

            console.log(JSON.stringify(args));
            Common.alert(JSON.stringify(args));

            console.log("==== onEventResized =====");
            console.log("args.newStart : " + args.newStart);
            console.log("args.newEnd : " + args.newEnd);
            console.log("args.e.id : " + args.e.id);
            console.log("content : " + content);
            console.log("==== onEventResized =====");

        };

        dp.onBeforeHeaderRender = function(args) {

        };

        dp.onBeforeEventRender = function(args) {
            //args.data.fontColor = "red";
        };

        // event creating
        dp.onTimeRangeSelected = function (args) {

            Common.prompt("New event name:", "Event", function(){

                var content = $("#promptText").val();

                alert(content);

                dp.clearSelection();
                if (!content) return;
                var e = new DayPilot.Event({
                    start: args.start,
                    end: args.end,
                    id: DayPilot.guid(),
                    text: content
                });
                dp.events.add(e);

                console.log("==== Created =====");
                console.log("args.start : " + args.start);
                console.log("args.end : " + args.end);
                console.log("DayPilot.guid() : " + DayPilot.guid());
                console.log("content : " + content);
                console.log("==== Created =====");
            });

        };

        dp.onEventClicked = function(args) {
            var content = args.e.data.text;

            console.log(JSON.stringify(args));
            console.log("==== onEventClicked =====");
            console.log("args.start : " + new DayPilot.Date(args.e.data.start));
            console.log("args.end : " + new DayPilot.Date(args.e.data.end));
            console.log("args.e.id : " + args.e.data.id);
            console.log("content : " + content);
            console.log("==== onEventClicked =====");

            Common.prompt("수정 하시겠습니까??:", content, function(){

                if (!content) return;

                content = $("#promptText").val();
                args.e.text(content);
                dp.events.update(args.e);

            });
        };

//  지원 안함.. ㅡ.ㅡ;
//        dp.eventDoubleClickHandling = "Enabled";
//
//        dp.onEventDoubleClicked = function(args) {
//            console.log("Event with id " + args.e.id() + " was double-clicked");
//
//            var content = args.e.data.text;
//
//            Common.prompt("수정 할텨??:", content, function(){
//
//                if (!content) return;
//
//                content = $("#promptText").val();
//                args.e.text(content);
//                dp.events.update(args.e);
//
//            });
//
//        };


        dp.onHeaderClicked = function(args) {
            Common.alert("day: " + args.header.dayOfWeek);
        };

        dp.init();
    });

    function fn_getInfo(){
        console.log(JSON.stringify(dp.events.list));
        // [{"id":"5","text":"Calendar Event 5","start":"2017-10-30T10:30:00","end":"2017-10-30T16:30:00"},{"id":"6","text":"Calendar Event 6","start":"2017-10-30T09:00:00","end":"2017-10-30T14:30:00"},{"id":"7","text":"Calendar Event 7","start":"2017-10-30T12:00:00","end":"2017-10-30T16:00:00"}]

        var eventObjList = dp.events.list;
        var selectObj = Common.findJson(eventObjList, "id", 5);
        console.log(JSON.stringify(selectObj));
        Common.alert(JSON.stringify(selectObj));
    }

    function fn_addInfo(){

        var e = new DayPilot.Event({
            start: new DayPilot.Date("2017-10-30T17:00:00"),
            end: new DayPilot.Date("2017-10-30T18:01:00"),
            id: DayPilot.guid(),
            text: "Add Event"
        });

        dp.events.add(e);
    }

    function fn_getIndex(){
        var eventObjList = dp.events.list;
        var selectObj = Common.findJson(eventObjList, "id", 5);
        var idx = DayPilot.indexOf(dp.events.list, selectObj[0]);
        console.log("fn_getIndex index : " + idx);
        Common.alert("fn_getIndex index : " + idx);
    }

    function fn_removeInfo(){
        var eventObjList = dp.events.list;
        var selectObj = Common.findJson(eventObjList, "id", 6);
        var idx = DayPilot.indexOf(dp.events.list, selectObj[0]);
        console.log("fn_removeInfo index : " + idx);
        if(idx < 0) return;
        dp.events.list.splice(idx,1);
        dp.update();
    }
</script>