<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript" language="javascript">
var sessionAuth = '${SESSION_INFO.userTypeId}';  //cody
var trDetailGrid;
var detailList;

$(document).ready(function(){

    if(sessionAuth == '2'){
    	$("#printSummary").show();
    }else{
    	$("#printSummary").hide();
    }

    if('${detailList}'=='' || '${detailList}' == null){
    }else{
    	detailList = JSON.parse('${detailList}');
       	console.log(detailList);
    }

    //AUIGrid 그리드를 생성합니다.
    creatDetailGrid();
});

function creatDetailGrid(){
    var trDColLayout = [
         {dataField : "trReciptNo", headerText : "<spring:message code="sal.title.bookNo" />", width : 150      },
         {dataField : "itmStusCode", headerText : "<spring:message code="sal.title.status" />", width : 150       },
         {dataField : "itmUpdBy", headerText : "<spring:message code="sal.title.updateBy" />", width : 150        },
         {dataField : "itmUpdDt", headerText : "<spring:message code="sal.title.updateDate" />", width : 150        }
         ];


   var trDOptions = {
              showStateColumn:false,
              showRowNumColumn    : true,
              usePaging : true,
              editable : false
        };

   trDetailGrid = GridCommon.createAUIGrid("#trDetailGrid", trDColLayout, "", trDOptions);

   if(detailList != '' ){
       AUIGrid.setGridData(trDetailGrid, detailList);
   }
}

function fn_printReport(){

   	 var trBookDtl = {
   			 trBookDtlId : '${detailInfo.trBookId }'
	 }

	//Generate Report
    $("#reportFileName").val('/sales/TRbookDetailsSummaryListing.rpt');
    $("#viewType").val('PDF');

    //title
     var date = new Date().getDate();
     if(date.toString().length == 1){
    	  date = "0" + date;
     }

   //Download File Name
     var title = "TRbookDetailsSummaryListing_"+date+(new Date().getMonth()+1)+new Date().getFullYear();
     $("#reportDownFileName").val(title);

     //Params
     $("#V_BOOKID").val(trBookDtl.trBookDtlId);

    //Gen Report
    var option = {
           isProcedure : false
    };
    Common.report("summDtlForm", option);
}

</script>

<form id="summDtlForm">
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType"/>
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" />
    <input type="hidden" id="V_BOOKID" name ="V_BOOKID" />
</form>
<div id="popup_wrap" class="popup_wrap size_mid"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1><spring:message code="sal.page.title.viewTrBook" /></h1>
<ul class="right_opt">
	<li><p class="btn_blue2"><a href="#"><spring:message code="sal.btn.close" /></a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.subtitle.trBookDetails" /></h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:160px" />
	<col style="width:*" />
	<col style="width:160px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.trBookNo" /></th>
	<td>${detailInfo.trBookNo } </td>
	<th scope="row"><spring:message code="sal.text.prefixNo" /></th>
	<td>${detailInfo.trBookPrefix }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.trNo" /></th>
	<td colspan="3">${detailInfo.trBookNoStart } To ${detailInfo.trBookNoEnd }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.status" /></th>
	<td>${detailInfo.trBookStusCode }</td>
	<th scope="row"><spring:message code="sal.text.totalPages" /></th>
	<td>${detailInfo.trBookPge }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.holderType" /></th>
	<td>${detailInfo.trHolderType }</td>
	<th scope="row"><spring:message code="sal.text.createBy" /></th>
	<td>${detailInfo.trBookCrtUserName }</td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.holder" /></th>
	<td>${detailInfo.trHolder }</td>
	<th scope="row"><spring:message code="sal.text.createAt" /></th>
	<td>${detailInfo.trBookCrtDt }</td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2><spring:message code="sal.page.subtitle.trReceiptInfo" /></h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
      <div id="trDetailGrid" style="width:100%; height:200px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
       <li><p class="btn_blue2"><a href="#" onclick="javascript:fn_printReport()" id="printSummary"><spring:message code="sal.btn.printSummary" /></a></p></li>
 </ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->