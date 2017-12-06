<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var myGridID_Info;
var myGridID_Q;
var myGridID_Target;


var columnLayout_info=[             
 {dataField:"eventType", headerText:'Event Type', width: 130, editable : true},
 {dataField:"eventName", headerText:'Event Name', width: 170, editable : true},
 {dataField:"inCharge", headerText:'In Charge of</br>the Event', width: 130, editable : true },
 {dataField:"date", headerText:'Date for</br>The Event', width: 130, editable : true, editRenderer : {type : "CalendarRenderer", showEditorBtnOver : true, showExtraDays : true} },
 {dataField:"request", headerText:'Requested</br>Complete Date', width: 130, editable : true, editRenderer : {type : "CalendarRenderer", showEditorBtnOver : true, showExtraDays : true}  },
 {dataField:"rate", headerText:'Complete</br>Condition Rate', width: 130, editable : true },
 {dataField:"com", headerText:'Complete</br>Status', editable : false},
];

var columnLayout_q=[             
 {dataField:"q1", headerText:'Question</br>Number', width: 100, editable : false},
 {dataField:"q2", headerText:'Feedback</br>Type', width: 200, editable : true},
 {dataField:"q3", headerText:'Question', editable : false},
];

var columnLayout_target=[             
 {dataField:"t1", headerText:'Sales Order', width: 250, editable : false},
 {dataField:"t2", headerText:'Name', width: 250, editable : true},
 {dataField:"t3", headerText:'Contact Number', width: 250, editable : false },
 {dataField:"t4", headerText:'Calling Agent', editable : false},
];


var gridOptions = {
	  headerHeight : 30,
      showStateColumn: false,
      showRowNumColumn    : false,
      usePaging : true,
      pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
      showFooter : false
};
  
var gridOptions2 = {
      showStateColumn: false,
      showRowNumColumn    : false,
      usePaging : true,
      pageRowCount : 20, //한 화면에 출력되는 행 개수 20(기본값:20)
      showFooter : false
};


$(document).ready(function(){

    myGridID_Info = GridCommon.createAUIGrid("grid_wrap_info", columnLayout_info, "", gridOptions);
    myGridID_Q = GridCommon.createAUIGrid("grid_wrap_q", columnLayout_q, "", gridOptions);
    myGridID_Target = GridCommon.createAUIGrid("grid_wrap_target", columnLayout_target, "", gridOptions2);

    
    var item_info = { "eventType" :  "", "eventName" : "", "inCharge" : "", "date" :  "", "request" :  "", "rate" :  "", "com" :  ""}; //row 추가
    AUIGrid.addRow(myGridID_Info, item_info, "last");
    
    //아이템 grid 행 추가
     $("#addRow_q").click(function() { 
    	var item_q = { "q1" :  "", "q2" : "", "q3" : ""}; //row 추가
    	AUIGrid.addRow(myGridID_Q, item_q, "last");
    });
    
     //아이템 grid 행 추가
     $("#addRow_target").click(function() { 
        var item_q = { "t1" :  "", "t2" : "", "t3" : "", "t4" : ""}; //row 추가
        AUIGrid.addRow(myGridID_Q, item_q, "last");
    });
  
  
}); //Ready


</script>   

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Survey Event Create</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->


<aside class="title_line"><!-- title_line start -->
<h2>Survey Event General Info</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_info" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Questionnaires</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#" id="addRow_q">add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="delRow_q()">del</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_q" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Target and Calling Agent</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#" id="addRow_target">add</a></p></li>
    <li><p class="btn_grid"><a href="#" onclick="delRow_target()">del</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_target" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="save">Save</a></p></li>
</ul>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->