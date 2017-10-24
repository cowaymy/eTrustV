<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">

var setMainRowIdx = 0;

function fnSelectBoxChanged()
{
   $("#menuCdNm").val("");
   $("#menuCdNm").focus();
}

function fnClose()
{
  $("#otdDetailPop").remove();
}

function fnSelectOTDDetailPopData()
{
     Common.ajax("GET"
               , "/scm/selectOtdSODetailPop.do"
               , $("#MainForm").serialize()
               , function(result) 
                 {
                    console.log("성공 fnPopUpSOGIDetailPopList: " + result.selectOtdSOGIDetailPopList.length);
                    console.log("성공 fnPopUpSOPPDetailPopList: " + result.selectOtdSOPPDetailPopList.length);

                    AUIGrid.setGridData(soGIGridID, result.selectOtdSOGIDetailPopList);
                    AUIGrid.setGridData(soPPGridID, result.selectOtdSOPPDetailPopList);
                    if(result != null )
                    {
                        console.log("success_GI_poNo: " + result.selectOtdSOGIDetailPopList[0].poNo
                                   +"success_PP_poNo: " + result.selectOtdSOPPDetailPopList[0].poNo); 
                    }
                 }
               , function(jqXHR, textStatus, errorThrown)
                 {
                   try
                   {
                     console.log("Fail Status : " + jqXHR.status);
                     console.log("code : "        + jqXHR.responseJSON.code);
                     console.log("message : "     + jqXHR.responseJSON.message);
                     console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
                   }
                   catch (e)
                   {
                     console.log(e);
                   }
                   
                   Common.alert("Fail : " + jqXHR.responseJSON.message);
                 });

}
var otdSOGILayout = 
    [      
        {       
            dataField : "poNo",
            headerText : "<spring:message code='sys.scm.otdview.PO' />",
            width : "15%",
        },{
            dataField : "stockCode",
            headerText : "<spring:message code='sys.scm.otdview.StkCode' />",
            width : "10%",
        },{
            dataField : "stkDesc",
            headerText : "<spring:message code='sys.scm.otdview.StkDesc' />",
            width : "15%",
        },{
            dataField : "poQty",
            headerText :"<spring:message code='sys.scm.otdview.poQty' />",
            width : "10%"
        },{
            dataField : "soQty",
            headerText :"<spring:message code='sys.scm.otdview.soQty' />",
            width : "10%"
        },{
            dataField : "giQty",
            headerText :"<spring:message code='sys.scm.otdview.giQty' />",
            width : "10%"
        },{
            dataField : "soDate",
            headerText :"<spring:message code='sys.scm.otdview.soDate' />",
            width : "15%"
        },{
            dataField : "giDate",
            headerText :"<spring:message code='sys.scm.otdview.giDate' />",
            width : "15%"
        }
    ];




/***************************************************[ Main GRID] ***************************************************/    
var soGIGridID, soPPGridID;

$(document).ready(function()
{
   var gridOptions = {
                    usePaging : false,
                    useGroupingPanel : false,
                    editable : false,
                    showRowNumColumn : false  // 그리드 넘버링
                  };

    /********************************
      soGI GRID
    *********************************/
      
      // AUIGrid 그리드를 생성합니다.
      soGIGridID = GridCommon.createAUIGrid("soGIGridDiv", otdSOGILayout,"", gridOptions);

      // cellClick event.
      AUIGrid.bind(soGIGridID, "cellClick", function( event ) 
      {
          console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedParammenuId: " + $("#searchParamMenuId").val() +" / "+ $("#searchParammenuName").val());        
      });

      // 셀 더블클릭 이벤트 바인딩
      AUIGrid.bind(soGIGridID, "cellDoubleClick", function(event) 
      {
          console.log("GI_DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
      });  



    /********************************
      soPP GRID
    *********************************/

    var otdSOPPLayout = 
        [      
            {       
                dataField : "poNo",
                headerText : "<spring:message code='sys.scm.otdview.PO' />",
                width : "10%",
            },{
                dataField : "stockCode",
                headerText : "<spring:message code='sys.scm.otdview.StkCode' />",
                width : "10%",
            },{
                dataField : "stkDesc",
                headerText : "<spring:message code='sys.scm.otdview.StkDesc' />",
                width : "10%",
            },{
                dataField : "poQty",
                headerText :"<spring:message code='sys.scm.otdview.poQty' />",
                width : "10%",
            },{
                dataField : "soNo",
                headerText :"<spring:message code='sys.scm.otdview.soNo' />",
                width : "10%",
            },{
                dataField : "soQty",
                headerText :"<spring:message code='sys.scm.otdview.soQty' />",
                width : "10%",
            },{
                dataField : "planQty",
                headerText :"<spring:message code='sys.scm.otdview.planQty' />",
                width : "10%",
            },{
                dataField : "planDate",
                headerText :"<spring:message code='sys.scm.otdview.planDate' />",
                width : "10%",
            },{
                dataField : "resultQty",
                headerText :"<spring:message code='sys.scm.otdview.resultQty' />",
                width : "10%",
            },{
                dataField : "resultDate",
                headerText :"<spring:message code='sys.scm.otdview.resultDate' />",
                width : "10%",
            }
        ];    
       
    // AUIGrid 그리드를 생성합니다.
      soPPGridID = GridCommon.createAUIGrid("soPPGridDiv", otdSOPPLayout,"", gridOptions);

      // cellClick event.
      AUIGrid.bind(soPPGridID, "cellClick", function( event ) 
      {
          console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedParammenuId: " + $("#searchParamMenuId").val() +" / "+ $("#searchParammenuName").val());        
      });

   // 셀 더블클릭 이벤트 바인딩
      AUIGrid.bind(soPPGridID, "cellDoubleClick", function(event) 
      {
          console.log("PP_DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
      });  

   // Call
      fnSelectOTDDetailPopData();
   
});   //$(document).ready


</script>

<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>SCM Master Management Add New</h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<div class="divine_auto"><!-- divine_auto start -->

<div style="width:35%;">

<div class="border_box" style="height:670px;"><!-- border_box start -->

<ul class="right_btns">
	<li><p class="btn_blue"><a href="#"><span class="search"></span>Search</a></p></li>
</ul>

<table class="type1 mt10"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Stock Type</th>
	<td>
	<select class="w100p">
		<option value="">11</option>
		<option value="">22</option>
		<option value="">33</option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Category</th>
	<td>
	<select class="w100p">
		<option value="">11</option>
		<option value="">22</option>
		<option value="">33</option>
	</select>
	</td>
</tr>
<tr>
	<th scope="row">Stock Name</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

</div><!-- border_box end -->

</div>

<div style="width:65%;">

<div class="border_box"><!-- border_box start -->

<aside class="title_line"><!-- title_line start -->
<h2>Stock Info</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Stock Code</th>
	<td colspan="3">
	<input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly" />
	</td>
</tr>
<tr>
	<th scope="row">Stock Type</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly" />
	</td>
	<th scope="row">Category</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly" />
	</td>
</tr>
<tr>
	<th scope="row">Description</th>
	<td colspan="3">
	<input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly" />
	</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Sales Planning</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Target</th>
	<td colspan="3">
	<label><input type="radio" name="target" /><span>Yes</span></label>
	<label><input type="radio" name="target" /><span>No</span></label>
	</td>
</tr>
<tr>
	<th scope="row">Started</th>
	<td>
	<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
	</td>
	<th scope="row">Ended</th>
	<td>
	<input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" />
	</td>
</tr>
<tr>
	<th scope="row">Memo</th>
	<td colspan="3">
	<textarea cols="20" rows="5" placeholder=""></textarea>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Supply Planning</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:110px" />
	<col style="width:*" />
	<col style="width:100px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row">Target</th>
	<td colspan="3">
	<label><input type="radio" name="target2" /><span>KL</span></label>
	<label><input type="radio" name="target2" /><span>KK</span></label>
	<label><input type="radio" name="target2" /><span>JB</span></label>
	<label><input type="radio" name="target2" /><span>PN</span></label>
	<label><input type="radio" name="target2" /><span>KC</span></label>
	</td>
</tr>
<tr>
	<th scope="row">Safety Stock</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p al_right" />
	</td>
	<th scope="row">LT</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p al_right" />
	</td>
</tr>
<tr>
	<th scope="row">MOQ</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p al_right" />
	</td>
	<th scope="row">Loading Quantity</th>
	<td>
	<input type="text" title="" placeholder="" class="w100p al_right" />
	</td>
</tr>
<tr>
	<th scope="row">Remark</th>
	<td colspan="3">
	<textarea cols="20" rows="5" placeholder=""></textarea>
	</td>
</tr>
</tbody>
</table><!-- table end -->

<ul class="center_btns">
	<li><p class="btn_blue2 big"><a href="#">Save</a></p></li>
	<li><p class="btn_blue2 big"><a href="#">Delete</a></p></li>
	<li><p class="btn_blue2 big"><a href="#">Close</a></p></li>
</ul>

</div><!-- border_box end -->

</div>

</div><!-- divine_auto end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

</body>
</html>