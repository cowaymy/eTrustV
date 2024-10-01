<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>


<script type="text/javaScript" language="javascript">


var  gridID;


$(document).ready(function(){

	$("#table1").hide();

	/* if("${SESSION_INFO.userTypeId}" == "1" ||"${SESSION_INFO.userTypeId}" == "2" ){ */
	if("${SESSION_INFO.userTypeId}" == "1" ){
        $("#table1").show();
    }

	if("${SESSION_INFO.memberLevel}" =="1"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="2"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="3"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");

    }else if("${SESSION_INFO.memberLevel}" =="4"){

        $("#orgCode").val("${orgCode}");
        $("#orgCode").attr("class", "w100p readonly");
        $("#orgCode").attr("readonly", "readonly");

        $("#grpCode").val("${grpCode}");
        $("#grpCode").attr("class", "w100p readonly");
        $("#grpCode").attr("readonly", "readonly");

        $("#deptCode").val("${deptCode}");
        $("#deptCode").attr("class", "w100p readonly");
        $("#deptCode").attr("readonly", "readonly");

        $("#memCode").val("${memCode}");
        $("#memCode").attr("class", "w100p readonly");
        $("#memCode").attr("readonly", "readonly");
    }


	 var optionUnit = {
             id: "stusCodeId",              // 콤보박스 value 에 지정할 필드명.
             name: "codeName",  // 콤보박스 text 에 지정할 필드명.
             isShowChoose: false,
             type : 'M'
     };

     CommonCombo.make('cmbStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 23} , "" , optionUnit);

     var optionUnit = {
             id: "code",              // 콤보박스 value 에 지정할 필드명.
             name: "codeName",  // 콤보박스 text 에 지정할 필드명.
             isShowChoose: false,
             isCheckAll : false,
             type : 'M'
     };


     CommonCombo.make('cmbSRVCStatus', "/status/selectStatusCategoryCdList.do", {selCategoryId : 24} , "ACT|!|REG|!|INV|!|SUS" , optionUnit);


    //AUIGrid 그리드를 생성합니다.
    createAUIGrid();

    AUIGrid.bind(gridID, "cellDoubleClick", function(event) {
    	console.log(event.rowIndex);
    	fn_goSVMDetails(gridID, event.rowIndex);
    });

    f_multiCombo();
    fn_keyEvent();

});


function fn_keyEvent(){


    $("#sRVContrtNo").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_selectListAjax();
            }
     });

    $("#orderNo").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_selectListAjax();
            }
      });

    $("#creator").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_selectListAjax();
            }
      });

    $("#custId").keydown(function(key)  {
            if (key.keyCode == 13) {
                fn_selectListAjax();
            }
      });

    $("#custName").keydown(function(key)  {
        if (key.keyCode == 13) {
            fn_selectListAjax();
            }
      });

    $("#custNRIC").keydown(function(key)  {
        if (key.keyCode == 13) {
            fn_selectListAjax();
            }
      });

}

function fn_clear(){

	$("#sRVContrtNo").val("");
	$("#cmbStatus").val("");
	$("#salesDate").val("");
	$("#cmbSRVCStatus").val("");
	$("#orderNo").val("");
	$("#creator").val("");
	$("#custId").val("");
	$("#custName").val("");
	$("#custNRIC").val("");

    $("text").each(function(){

        if($(this).hasClass("readonly")){
        }else{
            $(this).val("");
        }
    });

    $("#cmbStatus").multipleSelect("uncheckAll");
    $("#cmbSRVCStatus").multipleSelect("uncheckAll");

}


// 리스트 조회.
function fn_selectListAjax() {

    if( $("#sRVContrtNo").val() ==""  &&  $("#salesDate").val() ==""  &&  $("#orderNo").val() ==""  && $("#custNRIC").val() ==""){

        Common.alert("<spring:message code="sal.text.mustKeyIn3" />");
         return ;
     }


   Common.ajax("GET", "/sales/membershipRental/selectList", $("#listSForm").serialize(), function(result) {

	   console.log(result);
       AUIGrid.setGridData(gridID, result);
   });
}




function f_multiCombo(){

    $(function() {
        $('#MBRSH_STUS_ID').change(function() {

        }).multipleSelect({
            selectAll: true, // 전체선택
            width: '80%'
        });
        $('#MBRSH_STUS_ID').multipleSelect("checkAll");
    });
}


function createAUIGrid() {

        var columnLayout = [
                            { dataField : "srvCntrctRefNo", headerText  : "<spring:message code="sal.title.mbrshNo" />.",    width : 100,  editable : false},
                            { dataField : "salesOrdNo", headerText  : "<spring:message code="sal.title.ordNo" />.",width : 80,  editable: false },
                            { dataField : "code",   headerText  : "<spring:message code="sal.title.status" />",  width          : 60,   editable       : false},
                            { dataField : "cntrctRentalStus", headerText  : "<spring:message code="sal.title.rentStatus" />",  width          : 60, editable       : false },
                            { dataField : "srvCntrctNetMonth",headerText  : "<spring:message code="sal.title.netMth" />",  width          : 65,   editable       : false},
                            { dataField : "srvCntrctNetYear",         headerText  : "<spring:message code="sal.title.netYear" />",   width          : 70,     editable       : false },
                            { dataField : "srvPrdStartDt",       headerText  : "<spring:message code="sal.title.stDate" />",  width          : 90, editable       : false},
                            { dataField : "srvCntrctPacDesc",     headerText  : "<spring:message code="sal.title.package" />",  width          : 130,    editable       : false },
                            { dataField : "name1",      headerText  : "<spring:message code="sal.title.custName" />",   width          : 150,    editable       : false },
                            { dataField : "srvCntrctCrtDt",     headerText  : "<spring:message code="sal.title.created" />",    width          : 90,        editable       : false,dataType : "date", formatString : "dd-mm-yyyy"},
                            { dataField : "userName",     headerText  : "<spring:message code="sal.title.creator" />",    width : 100,       editable  : false}


       ];

        var gridPros = { usePaging : true,  pageRowCount: 20, editable: false,  headerHeight        : 30, showRowNumColumn : true};

        gridID = GridCommon.createAUIGrid("list_grid_wrap", columnLayout  ,"" ,gridPros);
    }



function  fn_goPayChannel(){


    var selectedItems = AUIGrid.getSelectedItems(gridID);

    if(selectedItems ==""){
       Common.alert("<spring:message code="sal.alert.title.membershipMissing" />"+DEFAULT_DELIMITER+"<spring:message code="sal.alert.msg.membershipMissing" /> ");
       return ;
    }

     var pram  ="?srvCntrctId="+selectedItems[0].item.srvCntrctId+"&srvCntrctOrdId="+selectedItems[0].item.srvCntrctOrdId+"&custId="+selectedItems[0].item.custId;
     Common.popupDiv("/sales/membershipRentalChannel/membershipRentalChannelPop.do"+pram ,null, null , true , '_PayChannelDiv1');


}

function fn_goLEDGER(){


    var selectedItems = AUIGrid.getSelectedItems(gridID);

    if(selectedItems ==""){
        Common.alert("<spring:message code="sal.alert.title.membershipMissing" />"+DEFAULT_DELIMITER+"<spring:message code="sal.alert.msg.membershipMissing" /> ");
        return ;
    }

     var pram  ="?srvCntrctId="+selectedItems[0].item.srvCntrctId+"&srvCntrctOrdId="+selectedItems[0].item.srvCntrctOrdId;
     Common.popupDiv("/sales/membershipRental/mRLedgerPop.do"+pram ,null, null , true , '_LedgerDiv1');

}

//Report
function fn_goKey_in_List(){
	Common.popupDiv("/sales/membershipRental/membershipRentalKeyInListPop.do" ,null, null , true , '_rptDiv1');
}

function fn_goSVMDetails(){


	  var selectedItems = AUIGrid.getSelectedItems(gridID);

      if(selectedItems ==""){
          Common.alert("<spring:message code="sal.alert.title.membershipMissing" />"+DEFAULT_DELIMITER+"<spring:message code="sal.alert.msg.membershipMissing" /> ");
          return ;
      }


      //contractID = this.RadGrid_SRVSales.SelectedValues["SrvContractID"].ToString();
      //Response.Redirect( "ServiceContract_Sales_View.aspx?ContractID=" + contractID);

      //$("#QUOT_ID").val(selectedItems[0].item.quotId);

      var pram  ="?srvCntrctId="+selectedItems[0].item.srvCntrctId;
      Common.popupDiv("/sales/membershipRental/mRContSalesViewPop.do"+pram ,null, null , true , '_ViewSVMDetailsDiv1');
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
<h2><spring:message code="sal.page.title.membershipMgmtRental" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a id="btnSrch" href="#" onClick="javascript:fn_goPayChannel();"><spring:message code="sal.btn.payChannel" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	<li><p class="btn_blue"><a href="#" onClick="javascript:fn_selectListAjax();" ><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
	</c:if>
	<li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#"  id="listSForm" name="listSForm" method="post">
	<input id="pdpaMonth" name="pdpaMonth" type="hidden" value='${PAGE_AUTH.pdpaMonth}'/>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
	<col style="width:180px" />
	<col style="width:*" />
</colgroup>
<tbody>
<tr>
	<th scope="row"><spring:message code="sal.text.membershipNo" />.<span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Rental Membership Number" class="w100p"   id="sRVContrtNo"  name="sRVContrtNo"/></td>
	<th scope="row"><spring:message code="sal.text.membershipStatus" /></th>
	<td>
	       <select class="multy_select w100p" multiple="multiple"  id ="cmbStatus" name="cmbStatus"  >
            </select>

	</td>
	<th scope="row"><spring:message code="sal.text.salesDate" /><span class="must">*</span></th>
	<td><input type="text" placeholder="DD/MM/YYYY" class="j_date w100p"   id="salesDate" name="salesDate" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.rentalStatus" /></th>
	<td>
			<select class="multy_select w100p" multiple="multiple"  id="cmbSRVCStatus"  name="cmbSRVCStatus">
            </select>

	</td>
	<th scope="row"><spring:message code="sal.text.ordNo" />.<span class="must">*</span></th>
	<td><input type="text" title="" placeholder="Order No" class="w100p"  id="orderNo" name="orderNo"/></td>
	<th scope="row"><spring:message code="sal.text.creator" /></th>
	<td><input type="text" title="" placeholder="Creator" class="w100p"  id="creator" name="creator" /></td>
</tr>
<tr>
	<th scope="row"><spring:message code="sal.text.customerId" /></th>
	<td><input type="text" title="" placeholder="Customer ID (Numberic)" class="w100p"  id="custId"  name="custId"/></td>
	<th scope="row"><spring:message code="sal.text.custName" /></th>
	<td><input type="text" title="" placeholder="Customer Name" class="w100p"  id="custName"  name="custName"/></td>
	<th scope="row"><spring:message code="sal.text.nric" />/<spring:message code="sal.text.companyNo" />.</th>
	<td><input type="text" title="" placeholder="NRIC/Company No." class="w100p" id="custNRIC"  name="custNRIC"  /></td>
</tr>
<tr>
    <th scope="row" colspan="6" ><span class="must"> <spring:message code="sal.text.mustKeyIn3" /></span>  </th>
</tr>
</tbody>
</table><!-- table end -->

<table class="type1"  id="table1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.orgCode" /></th>
    <td>
       <input type="text" title="" id="orgCode" name="orgCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.grpCode" /></th>
    <td>
    <input type="text" title=""  id="grpCode"  name="grpCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.detpCode" /></th>
    <td>
    <input type="text" title=""   id="deptCode" name="deptCode" class="w100p" />
    </td>
    <th scope="row"><spring:message code="sal.text.memberCode" /></th>
    <td>
    <input type="text" title=""   id="memCode" name="memCode" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
	<dt><spring:message code="sales.Link" /></dt>
	<dd>
	<ul class="btns">

	</ul>
	<ul class="btns">

		<!-- <li><p class="link_btn"><a onclick="javascript:fn_goSVMDetails()" href="#">View Rental SVM Details</a></p></li> -->

		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		<li><p class="link_btn"><a onclick="javascript:fn_goLEDGER()" href="#"><spring:message code="sal.btn.link.ledger" /></a></p></li>
		</c:if>
		<c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}">
		<li><p class="link_btn type2"><a onclick="javascript:fn_goKey_in_List()"><spring:message code="sal.btn.link.keyInList" /></a></p></li>
		</c:if>
	</ul>
	<p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
	</dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
        <div id="list_grid_wrap" style="width:100%; height:360px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->