<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">



var membershipQuotInfoFilterGridID; // membershipQuotInfoFilterGridID list


$(document).ready(function(){  
	createFilterGrid();	 
});

function fn_getMembershipQuotInfoAjax (){
	  Common.ajax("GET", "/sales/membership/selectMembershipQuotInfo",$("#getParamForm").serialize(), function(result) {
		 console.log(result);
		 
		  $("#quotNo").html(result[0].quotNo);
		  $("#crtDt").html(result[0].crtDt);
		  $("#crtUserId").html(result[0].crtUserId);
		  
      });
}


function fn_getMembershipQuotInfoFilterAjax (){
      Common.ajax("GET", "/sales/membership/selectMembershipQuotFilter",$("#getParamForm").serialize(), function(result) {
         console.log(result);
         
         AUIGrid.setGridData(membershipQuotInfoFilterGridID, result);

         
      });
}


function createFilterGrid(){

	
    var membershipQuotInfoFilterLayout = [
         {dataField : "stkCode",headerText : "Code", width : 100},
         {dataField : "stkDesc", headerText : "Description", width : 280},
         {dataField : "stkPriod", headerText : "Change Period", width :100},
         {dataField : "stkFilterPrc", headerText : "Filter Price", width :100},
         {dataField : "stkChrgPrc", headerText : "Charge Price", width :100},
         {dataField : "stkLastChngDt", headerText : "Last Change Date",width :120}
   ];

    //그리드 속성 설정
    var gridPros = {
        usePaging           : true,             //페이징 사용
        pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
        editable                : false,            
        fixedColumnCount    : 1,            
        showStateColumn     : true,             
        displayTreeOpen     : false,            
        selectionMode       : "singleRow",  //"multipleCells",            
        headerHeight        : 30,       
        useGroupingPanel    : false,        //그룹핑 패널 사용
        skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
        noDataMessage       : "No order found.",
        groupingMessage     : "Here groupping"
    };
    
    membershipQuotInfoFilterGridID = GridCommon.createAUIGrid("#filter_grid_wrap", membershipQuotInfoFilterLayout,'',gridPros); 
}



//resize func (tab click)
 function fn_resizefunc(gridName){ // 
     AUIGrid.resize(gridName, 920, 300);
} 

</script>


<!-- get param Form  -->
<form id="getParamForm" method="get">
    <input type="hidden" name="QUOT_ID"  id="QUOT_ID" value="${membershipInfoTab.quotId}"/>
</form>


<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Membership Management - View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->


<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Membership Info</a></li>
    <li><a href="#">Order Info</a></li>
    <li><a href="#">Contact Info</a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(membershipQuotInfoFilterGridID)"> Filter Charge Info</a></li>
</ul>

<article class="tap_area"><!-- tap_area start   MembershipInfo tab -->

<table class="type1"><!-- table start   -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Membership No</th>
    <td><span>${membershipInfoTab.mbrshNo}</span></td>
    <th scope="row">Bill No</th>
    <td><span>${membershipInfoTab.mbrshBillNo}</span></td>
    <th scope="row">Status</th>
    <td><span>${membershipInfoTab.mbrshStusName}</span></td>
</tr>
<tr>
    <th scope="row">Package Code</th>
    <td><span>${membershipInfoTab.pacCode}</span></td>
    <th scope="row">Package Name</th>
    <td colspan="3"><span>${membershipInfoTab.pacName}</span></td>
</tr>
<tr>
    <th scope="row">Start Date</th>
    <td><span>${membershipInfoTab.mbrshStartDt} </span></td>
    <th scope="row">Expire Date</th>
    <td><span>${membershipInfoTab.mbrshExprDt}</span></td>
    <th scope="row">Duration</th>
    <td><span>${membershipInfoTab.mbrshDur}</span></td>
</tr>
<tr>
    <th scope="row">Total Amount</th>
    <td><span>${membershipInfoTab.mbrshTotAmt}</span></td>
    <th scope="row">Package Amount</th>
    <td><span>${membershipInfoTab.mbrshPacAmt}</span></td>
    <th scope="row">Filter Amount</th>
    <td><span>${membershipInfoTab.mbrshFilterAmt}</span></td>
</tr>
<tr>
    <th scope="row">BS Frequency</th>
    <td><span>${membershipInfoTab.mbrshFreq}</span></td>
    <th scope="row">Outstanding</th>
    <td><span>${membershipInfoTab.mbrshOtstnd}</span></td>
    <th scope="row">Creator</th>
    <td><span>${membershipInfoTab.mbrshCrtUserId}</span></td>
</tr>
<tr>
    <th scope="row">Key-In Branch</th>
    <td colspan="3">
          <span>  ${membershipInfoTab.brnchCode} <c:if test="${not empty membershipInfoTab.brnchCode}"> -  ${membershipInfoTab.brnchName} </c:if> </span>
     </td>
    <th scope="row">Create Date</th>
    <td><span>${membershipInfoTab.mbrshCrtDt}  </span></td>
</tr>
<tr>
    <th scope="row">Package Promotion</th>
    <td colspan="5">
          <span>  ${membershipInfoTab.mbrshPacPromoCode} <c:if test="${not empty membershipInfoTab.mbrshPacPromoCode}"> -  ${membershipInfoTab.mbrshPacPromoName} </c:if> </span>
    
    </td>
</tr>
<tr>
    <th scope="row">Filter Promotion</th>
     <td colspan="5">
          <span>  ${membershipInfoTab.mbrshPromoCode} <c:if test="${not empty membershipInfoTab.mbrshPromoCode}"> -  ${membershipInfoTab.mbrshPromoName} </c:if> </span>
    
    </td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span> ${membershipInfoTab.mbrshSalesMemCode} </span></td>
    <th scope="row">Salesman Name</th>
    <td colspan="3"><span> ${membershipInfoTab.mbrshSalesMemName} </span></td>
</tr>
<tr>
    <th scope="row">Quotation No</th>
    <td><span id="quotNo"></span></td>
    <th scope="row">Create Date</th>
    <td><span id="crtDt"></span></td>
    <th scope="row">Creator</th>
    <td><span id="crtUserId"></span></td>
</tr>
</tbody>
</table><!-- table end     -->

</article><!-- tap_area end   MembershipInfo tab-->





<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Order No</th>
    <td><span>${orderInfoTab.ordNo}</span></td>
    <th scope="row">Order Date</th>
    <td><span>${orderInfoTab.ordDt}</span></td>
    <th scope="row">Order Status</th>
    <td><span>${orderInfoTab.ordStusName}</span></td>
</tr>
<tr>
    <th scope="row">Product Category</th>
    <td colspan="3"><span>${orderInfoTab.codeName}</span></td>
    <th scope="row">Application Type</th>
    <td><span>${orderInfoTab.appTypeCode}</span></td>
</tr>
<tr>
    <th scope="row">Product Code</th>
    <td><span>${orderInfoTab.stockCode}</span></td>
    <th scope="row">Product Name</th>
    <td colspan="3"><span>${orderInfoTab.stockDesc}</span></td>
</tr>
<tr>
    <th scope="row">Customer ID</th>
    <td><span>${orderInfoTab.custId}</span></td>
    <th scope="row">NRIC/Company No</th>
    <td colspan="3"><span>${orderInfoTab.custNric}</span></td>
</tr>
<tr>
    <th scope="row">Customer Name</th>
    <td colspan="5"><span>${orderInfoTab.custName}</span></td>
</tr>
<tr>
    <th scope="row">Install Address</th>
    <td colspan="5"><span>${contactInfoTab.instAddr1}&nbsp;${contactInfoTab.instAddr2}&nbsp; ${contactInfoTab.instAddr3}&nbsp;
                            ${contactInfoTab.instPostCode}&nbsp;${contactInfoTab.instArea}&nbsp;${contactInfoTab.instState}&nbsp;${contactInfoTab.instCnty}&nbsp;
     </span></td>
</tr>
</tbody>
</table><!-- table end -->


</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:100px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>

<tr>
    <th scope="row">Contact Person</th>
    <td colspan="7"><span>${membershipInfoTab.cntName}</span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td colspan="3"><span>${membershipInfoTab.cntNric}</span></td>
    <th scope="row">Gender</th>
    <td><span>${membershipInfoTab.cntGender}</span></td>
    <th scope="row">Race</th>
    <td><span>${membershipInfoTab.cntRace}</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span><span>${membershipInfoTab.cntTelM}</span></span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>${membershipInfoTab.cntTelR}</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${membershipInfoTab.cntTelO}</span></td>
    <th scope="row">Tel (Fax)</th>
    <td><span>${membershipInfoTab.cntTelF}</span></td>
</tr>
<tr>
    <th scope="row">Email</th>
    <td colspan="7"><span>${membershipInfoTab.cntEmail}</span></td>
</tr>
</tbody>
</table><!-- table end -->
</article><!-- tap_area end -->


<article class="tap_area"><!-- tap_area start -->
	<article class="grid_wrap"><!-- grid_wrap start -->
	    <div id="filter_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>  
	</article><!-- grid_wrap end -->
</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<script> 


    var quot = $("#QUOT_ID").val();
    console.log(quot);
    
    if(quot >0){ 
         fn_getMembershipQuotInfoAjax(); 
         fn_getMembershipQuotInfoFilterAjax();
    }
</script>
