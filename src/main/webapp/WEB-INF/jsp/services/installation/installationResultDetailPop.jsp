<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
	var myGridID_view;
	
	createInstallationViewAUIGrid();
	fn_viewInstallResultSearch();
	
	var callType = "${callType.typeId}";
	console.log(callType);
	if(callType == 0){
		$(".red_text").text( "* Installation information data error. Please contact to IT Department.");
	}else{
		if(callType == 258){
			//$(".tap_type1").li[1].text("Product Exchange Info");
		}else{
			
		}
		if("${orderInfo.c9}" == 21){
			$(".red_text").text( "* This installation status is failed. Please do the call log process again.");
		}else if("${orderInfo.c9}" == 4){
			$(".red_text").text( "* This installation status is completed.<br />  To reverse this order installation result, please proceed to order installation result reverse.");
		}else{
			
		}
	}

});

function fn_viewInstallResultSearch(){
    var jsonObj = { 
            installEntryId : $("#installEntryId").val()
       };
   Common.ajax("GET", "/services/viewInstallationSearch.do", jsonObj, function(result) {
       console.log("성공.");
       console.log("data : " + result);
       AUIGrid.setGridData(myGridID_view, result);
   });
   
}

function createInstallationViewAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "resultId",
        headerText : "ID",
        editable : false,
        width : 130
    }, {
        dataField : "code",
        headerText : "Status",
        editable : false,
        width : 180
    }, {
        dataField : "installDt",
        headerText : "Install Date",
        editable : false,
        width : 180
    }, {
        dataField : "memCode",
        headerText : "CT Code",
        editable : false,
        width : 250
    }, {
        dataField : "name",
        headerText : "CT Name",
        editable : false,
        width : 180
    }];
     // 그리드 속성 설정
    var gridPros = {
        
        // 페이징 사용       
        usePaging : true,
        
        // 한 화면에 출력되는 행 개수 20(기본값:20)
        pageRowCount : 20,
        
        editable : true,
        
        showStateColumn : true, 
        
        displayTreeOpen : true,
        
        
        headerHeight : 30,
        
        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
        skipReadonlyColumns : true,
        
        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
        wrapSelectionMove : true,
        
        // 줄번호 칼럼 렌더러 출력
        showRowNumColumn : false,

    };
    
    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID_view = AUIGrid.create("#grid_wrap_view", columnLayout, gridPros);
}

var gridPros = {
    
    // 페이징 사용       
    usePaging : true,
    
    // 한 화면에 출력되는 행 개수 20(기본값:20)
    pageRowCount : 20,
    
    editable : true,
    
    fixedColumnCount : 1,
    
    showStateColumn : true, 
    
    displayTreeOpen : true,
    
    selectionMode : "singleRow",
    
    headerHeight : 30,
    
    // 그룹핑 패널 사용
    useGroupingPanel : true,
    
    // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
    skipReadonlyColumns : true,
    
    // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
    wrapSelectionMove : true,
    
    // 줄번호 칼럼 렌더러 출력
    showRowNumColumn : false
    
};
</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Installation Result Detail</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Order Info</a></li>
    <li><a href="#">Customer Info</a></li>
    <li><a href="#">Installation Info</a></li>
    <li><a href="#">HP Info</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Order Information</h2>
</aside><!-- title_line end -->

<input type="hidden" value="<c:out value="${installResult.installEntryId}"/>" id="installEntryId"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Type</th>
    <td>
    <span><c:out value="${installResult.codename1}"/></span>
    </td>
    <th scope="row">Install No.</th>
    <td>
    <span><c:out value="${installResult.installEntryNo}"/></span>
    </td>
    <th scope="row">Order No.</th>
    <td>
    <span><c:out value="${installResult.salesOrdNo}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Ref No.</th>
    <td>
    <span><c:out value="${installResult.refNo}"/></span>
    </td>
    <th scope="row">Order Date</th>
    <td>
    <span><c:out value="${installResult.salesDt}"/></span>
    </td>
    <th scope="row">Application Type</th>
    <c:if test="${installResult.codeid1  == '257' }">
	    <td>
	    <span><c:out value="${orderInfo.codeName}"/></span>
	    </td>
	</c:if>
	<c:if test="${installResult.codeid1  == '258' }">
        <td>
        <span><c:out value="${orderInfo.c5}"/></span>
        </td>
    </c:if>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">
    <span><c:out value="${orderInfo.rem}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Last updated by</th>
	    <td>
	    <span><c:out value="${installResult.memCode}"/></span>
	    </td>
    <th scope="row">Product</th>
    <c:if test="${installResult.codeid1  == '257' }">
	    <td>
	    <span><c:out value="${orderInfo.stkCode} - ${orderInfo.stkDesc} " /></span>
	    </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
	    <td>
	    <span><c:out value="${orderInfo.c6} - ${orderInfo.c7} " /></span>
	    </td>
    </c:if>
    <th scope="row">Promotion</th>
    <c:if test="${installResult.codeid1  == '257' }">
	    <td>
	    <span><c:out value="${orderInfo.c3} - ${orderInfo.c4} " /></span>
	    </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
	     <td>
	    <span><c:out value="${orderInfo.c9} - ${orderInfo.c10} " /></span>
	    </td>
    </c:if>
</tr>
<tr>
    <th scope="row">Price</th>
    <c:if test="${installResult.codeid1  == '257' }">
	    <td>
	    <span><c:out value="${orderInfo.c5}"/></span>
	    </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
	    <td>
	    <span><c:out value="${orderInfo.c12}"/></span>
	    </td>
    </c:if>
    <th scope="row">PV</th>
    <c:if test="${installResult.codeid1  == '257' }">
	    <td>
	    <span><c:out value="${orderInfo.c6}"/></span>
	    </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
	    <td>
	    <span><c:out value="${orderInfo.c13}"/></span>
	    </td>
    </c:if>
    <th scope="row"></th>
    <td>
    </td>
</tr>
<tr>
      <th scope="row">Prev Service Area</th>
    <c:if test="${installResult.codeid1  == '257' }">
        <td>
        <span><c:out value="${orderInfo.prevSvcArea}"/></span>
        </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
        <td>
        <span><c:out value="${orderInfo.prevSvcArea}"/></span>
        </td>
    </c:if>
    <th scope="row">Next Service Area</th>
    <c:if test="${installResult.codeid1  == '257' }">
        <td>
        <span><c:out value="${orderInfo.nextSvcArea}"/></span>
        </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
        <td>
        <span><c:out value="${orderInfo.nextSvcArea}"/></span>
        </td>
    </c:if>
   <th scope="row">Distance</th>
    <c:if test="${installResult.codeid1  == '257' }">
        <td>
        <span><c:out value="${orderInfo.distance}"/></span>
        </td>
    </c:if>
    <c:if test="${installResult.codeid1  == '258' }">
        <td>
        <span><c:out value="${orderInfo.distance}"/></span>
        </td>
    </c:if>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Customer Name</th>
    <td>
   <span><c:out value="${customerInfo.name}"/></span>
    </td>
    <th scope="row">Customer NRIC</th>
    <td>
    <span><c:out value="${customerInfo.nric}"/></span>
    </td>
    <th scope="row">Gender</th>
    <td>
    <span><c:out value="${customerInfo.gender}"/></span>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="4">Mailing Address</th>
    <td colspan="5">
    <span>1111</span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span>1111</span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span>1111</span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span>1111</span>
    </td>
</tr>
<tr>
    <th scope="row">Contact Person</th>
    <td>
    <span><c:out value="${customerContractInfo.name}"/></span>
    </td>
    <th scope="row">Gender</th>
    <td>
    <span><c:out value="${customerContractInfo.gender}"/></span>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <span><c:out value="${customerContractInfo.telR}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <span><c:out value="${customerContractInfo.telM1}"/></span>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <span><c:out value="${customerContractInfo.telO}"/></span>
    </td>
    <th scope="row">Fax No.</th>
    <td>
    <span><c:out value="${customerContractInfo.telF}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Request Install Date</th>
    <td>
    <span><c:out value="${installResult.c3}"/></span>
    </td>
    <th scope="row">Assigned CT</th>
    <td colspan="3">
     <span><c:out value="(${installResult.memCode}) ${installResult.name2}"/></span>
    </td>
</tr>
<tr>
    <th scope="row" rowspan="4">Installation Address</th>
    <td colspan="5">
    <span>1111</span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span>1111</span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span>1111</span>
    </td>
</tr>
<tr>
    <td colspan="5">
    <span>1111</span>
    </td>
</tr>
<tr>
    <th scope="row">Special Instruction</th>
    <td>
    <span>1111</span>
    </td>
    <th scope="row">Preferred Date</th>
    <td>
    </td>
    <th scope="row">Preferred Time  </th>
    <td>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Installation Contact Person:</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Name</th>
    <td>
    <span><c:out value="${installationContract.name}"/></span>
    </td>
    <th scope="row">Gender</th>
    <td>
    </td>
    <th scope="row">Residence No.</th>
    <td>
    <span><c:out value="${installationContract.telR}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.  </th>
    <td>
    <span><c:out value="${installationContract.telM1}"/></span>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <span><c:out value="${installationContract.telO}"/></span>
    </td>
    <th scope="row">Fax No.</th>
    <td>
    <span><c:out value="${installationContract.telF}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>HP Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:135px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">HP/Cody Code</th>
    <td>
    <span><c:out value="${hpMember.memCode}"/></span>
    </td>
    <th scope="row">HP/Cody Name</th>
    <td>
    <span><c:out value="${hpMember.name1}"/></span>
    </td>
    <th scope="row">HP/Cody NRIC</th>
    <td>
    <span><c:out value="${hpMember.nric}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Mobile No.</th>
    <td>
    <span><c:out value="${hpMember.telMobile}"/></span>
    </td>
    <th scope="row">House No.</th>
    <td>
    <span><c:out value="${hpMember.telHuse}"/></span>
    </td>
    <th scope="row">Office No.</th>
    <td>
    <span><c:out value="${hpMember.telOffice}"/></span>
    </td>
</tr>
<tr>
    <th scope="row">Department Code</th>
    <td>
    <span><c:out value="${salseOrder.deptCode}"/></span>
    </td>
    <th scope="row">Group Code</th>
    <td>
    <span><c:out value="${salseOrder.grpCode}"/></span>
    </td>
    <th scope="row">Organization Code</th>
    <td>
    <span><c:out value="${salseOrder.orgCode}"/></span>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<aside class="title_line mt30"><!-- title_line start -->
<h2>View Installation Result</h2>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_view" style="width: 100%; height:100px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

<p class="red_text"> </p>
</section><!-- pop_body end -->

</div><!-- popup_wrap end -->
