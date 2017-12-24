<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {
	doGetComboSepa("/common/selectBranchCodeList.do",'5' , '-',''   , 'dscCode' , 'S', '');

	//grid 생성
	createInstallationListAUIGrid();
	AUIGrid.setSelectionMode(myGridID, "singleRow");

	 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) {
          //alert(event.rowIndex+ " - double clicked!! : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId"));
          var statusCode =  AUIGrid.getCellValue(myGridID, event.rowIndex, "code1");
          if(statusCode == "ACT"){
        	 // alert(AUIGrid.getCellValue(myGridID, event.rowIndex, "code1"));
        	  //Common.alert("Installation is under status [active]. No result to view.");
        	  Common.alert("<spring:message code='service.msg.activeView'/> ");
          }else{
        	 // alert(AUIGrid.getCellValue(myGridID, event.rowIndex, "code1"));
        	  Common.popupDiv("/services/installationResultDetailPop.do?isPop=true&installEntryId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId")+"&codeId=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "codeid1"));
          }
      });

    AUIGrid.bind(myGridID, "cellClick", function(event) {
      //alert(event.rowIndex+ " -cellClick : " + event.value + " - rowValue : " + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid"));
      installEntryId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "installEntryId");
      codeid1 = AUIGrid.getCellValue(myGridID, event.rowIndex, "codeid1");
      orderId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");
      docId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "c1");
      statusCode = AUIGrid.getCellValue(myGridID, event.rowIndex, "code1");
      salesOrderId =  AUIGrid.getCellValue(myGridID, event.rowIndex, "salesOrdId");

      //Common.popupDiv("/organization/requestTerminateResign.do?isPop=true&MemberID=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "memberid")+"&MemberType=" + AUIGrid.getCellValue(myGridID, event.rowIndex, "membertype"), "");
  });



});

function fn_installationListSearch(){
	Common.ajax("GET", "/services/installationListSearch.do", $("#searchForm").serialize(), function(result) {
        console.log("성공.");
        console.log( result);
        AUIGrid.setGridData(myGridID, result);
    });
}

function fn_addInstallation(codeid1){//active 일때만 열림


	var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if(selectedItems.length  <= 0) {
        //Common.alert("<b>No AS selected.</b>");
        Common.alert("<spring:message code='expense.msg.NoData'/> ");
        return ;
    }


    if(selectedItems.length  > 1) {
        //Common.alert("<b>only select one row plz</b>");
        Common.alert("<b><spring:message code='service.msg.onlyPlz'/><b>");
        return ;
    }


	var   installEntryId =   selectedItems[0].item.installEntryId;
	var   codeid1 =  selectedItems[0].item.codeid1;
	var  orderId =   selectedItems[0].item.salesOrdId;
	var docId =  selectedItems[0].item.c1;
	var  statusCode =  selectedItems[0].item.code1;
	var  salesOrderId =  selectedItems[0].item.salesOrdId;


	if(statusCode == "ACT"){
		if(codeid1 == 257){
	           Common.popupDiv("/services/addInstallationPopup.do?isPop=true&installEntryId=" + installEntryId+"&codeId=" + codeid1
	        		  , ""
        	          , null
        	          , "false"
        	          , "addInstallationPopupId");
	    }else{
	         Common.popupDiv("/services/addinstallationResultProductDetailPop.do?isPop=true&installEntryId=" + installEntryId+"&codeId=" + codeid1+"&orderId=" +orderId+"&docId=" +docId+"&salesOrderId="+salesOrderId
	        		 , ""
                     , null
                     , "false"
                     , "addinstallationResultProductDetailPopId"
	         );
	    }
	}else{
		//Common.alert("Installation is no longer active. Add new installatio result is disallowed.");
		Common.alert("<spring:message code='service.msg.InstallationAdd'/> ");
	}
}



var myGridID;
function createInstallationListAUIGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [ {
        dataField : "code",
        headerText : '<spring:message code="service.grid.Type" />',
        editable : false,
        width : 130
    }, {
        dataField : "installEntryNo",
        headerText : '<spring:message code="service.grid.InstallNo" />',
        editable : false,
        width : 180
    }, {
        dataField : "salesOrdNo",
        headerText : '<spring:message code="service.grid.OrderNo" />',
        editable : false,
        width : 180
    }, {
        dataField : "c3",
        headerText : '<spring:message code="service.grid.AppDate" />',
        editable : false,
        width : 100
    }, {
        dataField : "stkDesc",
        headerText : '<spring:message code="service.grid.Product" />',
        editable : false,
        style : "my-column",
        width : 180
    }, {
        dataField : "name",
        headerText : '<spring:message code="service.grid.Customer" />',
        editable : false,
        width : 250
    }, {
        dataField : "codeName",
        headerText : '<spring:message code="service.grid.AppType" />',
        editable : false,
        width : 150

    }, {
        dataField : "brnchId",
        headerText : '<spring:message code="service.grid.AppBrnchId" />',
        editable : false,
        width : 100
    }, {
        dataField : "code1",
        headerText : '<spring:message code="service.grid.Status" />',
        width : 130
    }, {
        dataField : "installEntryId",
        headerText : "",
        width : 0
    }, {
        dataField : "codeid1",
        headerText : "",
        width :0
    }, {
        dataField : "c1",
        headerText : "",
        width : 0
    }, {
        dataField : "salesOrdId",
        headerText : "",
        width : 0
    }];



    // 그리드 속성 설정
   var gridPros = {
              showRowCheckColumn : true,
              // 페이징 사용
              usePaging : true,
              // 한 화면에 출력되는 행 개수 20(기본값:20)
              pageRowCount : 20,
              // 전체 체크박스 표시 설정
              showRowAllCheckBox : true,
              editable :  false
   };


    //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, gridPros);
    myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);
}

function fn_excelDown(){
    // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
    GridCommon.exportTo("grid_wrap", "xlsx", "<spring:message code='service.title.InstallationResultLogSearch'/>");
}




function fn_assginCTTransfer(){

    var selectedItems = AUIGrid.getCheckedRowItems (myGridID);


    if(selectedItems.length  <= 0) {
        //Common.alert("<b>No AS selected.</b>");
        Common.alert("<b><spring:message code='service.msg.NoData'/></b>");
        return ;
    }


    var brnchId = selectedItems[0].item.brnchId;

    if( brnchId =="") {
    	 Common.alert("<b>[" + selectedItems[i].item.installEntryNo + "] do no has any result[brnch] yet. .</br> ");
    	return ;
    }


    for( var  i in selectedItems){
         console.log("===>"+ selectedItems[i].item.brnchId);

         if("ACT" != selectedItems[i].item.code1 ){
             Common.alert("<b>[" + selectedItems[i].item.installEntryNo + "] do no has any result yet. .</br> Result view is disallowed.");
             return ;
         }

         if(brnchId != selectedItems[i].item.brnchId ){
        	 Common.alert("<b><spring:message code='service.msg.BranchCode'/></b>");
             //Common.alert("<b>동일한 브랜치 코드만 선택 가능합니다.</b>");
             return ;
         }
    }


    Common.popupDiv("/services/assignCTTransferPop.do"  , null, null , true , '_assginCTTransferDiv');
}

function fn_installationNote(){
	Common.popupDiv("/services/installationNotePop.do"  , null, null , true , '');
}

function fn_doActiveList(){
	Common.popupDiv("/services/doActiveListPop.do"  , null, null , true , '');
}

function fn_installRawData(){
	Common.popupDiv("/services/installationRawDataPop.do"  , null, null , true , '');
}

function fn_installBookListing(){
	Common.popupDiv("/services/installationLogBookPop.do"  , null, null , true , '');
}

function fn_dailyDscReport(){
    Common.popupDiv("/services/dailyDscReportPop.do"  , null, null , true , '');
}

function fn_installNoteListing(){
    Common.popupDiv("/services/installationNoteListingPop.do"  , null, null , true , '');
}
function fn_installFreeGiftList(){
    Common.popupDiv("/services/installationFreeGiftListPop.do"  , null, null , true , '');
}
function fn_DscReport(){
    Common.popupDiv("/services/installationDscReportPop.do"  , null, null , true , '');
}

function fn_editInstallation(){//active 일때만 열림


    var selectedItems = AUIGrid.getCheckedRowItems(myGridID);

    if(selectedItems.length  <= 0) {
        Common.alert("<b><spring:message code='service.msg.NoInstallation'/></b>");
        return ;
    }


    if(selectedItems.length  > 1) {
        //Common.alert("<b>only select one row plz</b>");
        Common.alert("<b><spring:message code='service.msg.onlyPlz'/></b>");
        return ;
    }


    var   installEntryId =   selectedItems[0].item.installEntryId;
    var   codeid1 =  selectedItems[0].item.codeid1;
    var  orderId =   selectedItems[0].item.salesOrdId;
    var docId =  selectedItems[0].item.c1;
    var  statusCode =  selectedItems[0].item.code1;
    var  salesOrderId =  selectedItems[0].item.salesOrdId;

    if(statusCode == "COM"){
               Common.popupDiv("/services/editInstallationPopup.do?isPop=true&installEntryId=" + installEntryId+"&codeId=" + codeid1);
    }else{
        //Common.alert("<b>Only completed installation result is allowed to edit.</b>");
        Common.alert("<b><spring:message code='service.msg.Onlycompleted'/></b>");
    }
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code='service.title.InstallationResultList'/></h2>
<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue"><a href="#" onClick="javascript:fn_assginCTTransfer()"><spring:message code='service.btn.AssginCTTransfer'/></a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_installationListSearch()"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
</c:if>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span><spring:message code='sal.btn.clear'/></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="searchForm">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:230px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code='service.title.Type'/></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="type" name="type">
        <option value="257">New Installation Order</option>
        <option value="258">Product Exchange</option>
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.InstallNo'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="installNo" name="installNo" /></td>
    <th scope="row"><spring:message code='service.title.AppointmentDate'/></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="startDate" name="startDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="endDate" name="endDate"/></p>
    </div><!-- date_set end -->
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.InstallDate'/></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" id="instalStrlDate" name="instalStrlDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" id="installEndDate" name="installEndDate"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code='service.title.OrderNo'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="orderNo" name="orderNo"/></td>
    <th scope="row"><spring:message code='service.title.OrderRefNo'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="orderRefNo" name="orderRefNo"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.PONo'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="poNo" name="poNo"/></td>
    <th scope="row"><spring:message code='service.title.OrderDate'/></th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" id="orderDate" name="orderDate"/></td>
    <th scope="row"><spring:message code='service.title.ApplicationType'/></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="appType" name="appType">
        <c:forEach var="list" items="${appTypeList }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.InstallationStatus'/></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="installStatus" name="installStatus">
        <c:forEach var="list" items="${installStatus }" varStatus="status">
           <option value="${list.codeId}">${list.codeName}</option>
        </c:forEach>
    </select>
    </td>
    <th scope="row"><spring:message code='service.title.CTCode'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="ctCode" name="ctCode"/></td>
    <th scope="row"><spring:message code='service.title.DSCCode'/></th>
    <td>
    <select class="w100p" id="dscCode" name="dscCode">
        <option value="">11</option>
        <option value="">22</option>
        <option value="">33</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.CustomerID'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="customerId" name="customerId"/></td>
    <th scope="row"><spring:message code='service.title.CustomerName'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="customerName" name="customerName"/></td>
    <th scope="row"><spring:message code='service.title.CustomerIC_CompanyNo'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="customerIc" name="customerIc"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code='service.title.SIRIMNo'/></th>
    <td><input type="text" class="w100p" title="" placeholder="" id="sirimNo" name="sirimNo"/></td>
    <th scope="row"><spring:message code='service.title.SerialNo'/></th>
    <td colspan="3"><input type="text" class="w100p" title="" placeholder="" id="serialNo" name="serialNo"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
<c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn"><a href="javascript:fn_addInstallation()" id="addInstallation"><spring:message code='service.btn.AddInstallationResult'/></a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcUserDefine4 == 'Y'}">
        <li><p class="link_btn"><a href="javascript:fn_editInstallation()" id="editInstallation"><spring:message code='service.btn.EditInstallationResult'/></a></p></li>
</c:if>
       <!--  <li><p class="link_btn"><a href="#">Edit Installation Result</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li> -->
    </ul>
    <ul class="btns">
        <!-- <li><p class="link_btn type2"><a href="#" onclick="Common.alert('The program is under development')">Installation Note</a></p></li> -->
<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_doActiveList()"><spring:message code='service.btn.DOActiveList'/></a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_installNoteListing()"><spring:message code='service.btn.InstallationNoteListing'/></a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_installationNote()"><spring:message code='service.btn.InstallationNote'/></a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_installBookListing()"><spring:message code='service.btn.InstallationLogBookListing'/></a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_installRawData()"><spring:message code='service.btn.InstallationRawData'/></a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_installFreeGiftList()"><spring:message code='service.btn.InstallationFreeGiftList'/></a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_dailyDscReport()"><spring:message code='service.btn.DailyDSCReport'/></a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript:fn_DscReport()"><spring:message code='service.btn.DSCReport'/></a></p></li>
</c:if>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid"><a href="#" onClick="fn_excelDown()"><spring:message code='service.btn.Generate'/></a></p></li>
</c:if>
   <!--  <li><p class="btn_grid"><a href="#">EDIT</a></p></li>
    <li><p class="btn_grid"><a href="#">NEW</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li> -->
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</form>
</section><!-- search_table end -->

</section><!-- content end -->
