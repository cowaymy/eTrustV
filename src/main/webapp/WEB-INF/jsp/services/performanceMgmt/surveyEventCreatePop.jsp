<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript">
var myGridID_Info;
var myGridID_Q;
var myGridID_Target;

var columnLayout_info=[             
 {dataField:"areaId", headerText:'Event Type', width: 130, editable : false},
 {dataField:"area", headerText:'Event Name', width: 130, editable : true},
 {dataField:"postcode", headerText:'In Charge of</br>the Event', width: 130, editable : false },
 {dataField:"city", headerText:'Date for</br>The Event', width: 130, editable : true },
 {dataField:"state", headerText:'Requested</br>Complete Date', width: 130, editable : true },
 {dataField:"country", headerText:'Complete</br>Condition Rate', width: 130, editable : false },
 {dataField:"id", headerText:'Complete</br>Status', editable : false},
];

var columnLayout_q=[             
 {dataField:"areaId2", headerText:'Question</br>Number', width: 100, editable : false},
 {dataField:"area2", headerText:'Feedback</br>Type', width: 200, editable : true},
 {dataField:"id2", headerText:'Question', editable : false},
];

var columnLayout_target=[             
 {dataField:"areaId3", headerText:'Sales Order', width: 250, editable : false},
 {dataField:"area3", headerText:'Name', width: 250, editable : true},
 {dataField:"country3", headerText:'Contact Number', width: 250, editable : false },
 {dataField:"id3", headerText:'Calling Agent', editable : false},
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

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_q" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<aside class="title_line"><!-- title_line start -->
<h2>Survey Target and Calling Agent</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap_target" style="width:100%; height:180px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->