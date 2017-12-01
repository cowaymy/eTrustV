<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javaScript" language="javascript">

	//AUIGrid 생성 후 반환 ID
	var editGridID;
	
	$(document).ready(function(){
	    
	    // AUIGrid 그리드를 생성합니다.
	    createEditAUIGrid();
	
	    //Call Ajax
	    fn_getStockEditListAjax();
	  
	    doGetCombo('/sales/pst/getInchargeList', '', $("#editInchargeSelect").val(),'editIncharge', 'S' , ''); //Incharge Person
	});
	
	function createEditAUIGrid() {
	    // AUIGrid 칼럼 설정
	    
	    // 데이터 형태는 다음과 같은 형태임,
	    //[{"id":"#Cust0","date":"2014-09-03","name":"Han","country":"USA","product":"Apple","color":"Red","price":746400}, { .....} ];
	    var columnLayout = [{
	            dataField : "stkCodeDesc",
	            headerText : "Stock Description",
	            editable : false
	        }, {
	            dataField : "pstItmReqQty",
	            headerText : "Request <br> Quantity",
	            width : 120,
	            editable : false
	        }, {
                dataField : "pstItmBalQty",
                headerText : "Balance <br> Quantity",
                width : 120,
                editable : false
            }, {
	            dataField : "pstItmCanQty2",
	            headerText : "Cancel <br> Quantity",
	            dataType:"numeric", 
                formatString:"###0",
	            width : 120
	        }, {
                dataField : "pstItmCanQty",
                headerText : "Cancel <br> Quantity",
                width : 120,
                visible : false
            }, {
	            dataField : "pstItmPrc",
	            headerText : "Item Price",
	            dataType:"numeric", 
	            formatString:"#,##0.00",
	            width : 130,
	            editable : false
	        }, {
                dataField : "pstStockRem",
                headerText : "Remark",
                width : 120
            }];
	   
	    // 그리드 속성 설정
	    var gridPros = {
	        // 페이징 사용       
	        usePaging : true,
	        // 한 화면에 출력되는 행 개수 20(기본값:20)
	        pageRowCount : 10,
	        editable : true,
	        fixedColumnCount : 1,
	        showStateColumn : false, 
	        displayTreeOpen : true,
	        selectionMode : "multipleCells",
	        headerHeight : 30,
	        // 그룹핑 패널 사용
	        useGroupingPanel : false,
	        // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
	        skipReadonlyColumns : true,
	        // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
	        wrapSelectionMove : true,
	        // 줄번호 칼럼 렌더러 출력
	        showRowNumColumn : true,
	        groupingMessage : "Here groupping"
	    };
	    
	    editGridID = GridCommon.createAUIGrid("#stockEdit_grid_wrap", columnLayout, gridPros);
	}
	
	function fn_getStockEditListAjax(){
	    Common.ajax("GET", "/sales/pst/getPstStockJsonDetailPop",$("#getParamForm").serialize(), function(result) {
	        AUIGrid.setGridData(editGridID, result);
	    });
	}
	
	//resize func (tab click)
	function fn_resizefunc(gridName){ // 
	    AUIGrid.resize(gridName, 900, 250);
	}
	
	function fn_updateStockList() {
		
//		alert(GridCommon.getEditData(editGridID));
        var pstRequestDOForm = {
            dataSet     : GridCommon.getEditData(editGridID),
            pstSalesMVO : {
                pstSalesOrdId : getParamForm.pstSalesOrdId.value,
                pstRefNo        : getParamForm.pstRefNo.value,
//                curType         : pstInfoForm.curType.value,
//                editCurRate    : pstInfoForm.editCurRate.value,
//                editIncharge   : pstInfoForm.editIncharge.value
            }
        };
      
        Common.ajax("POST", "/sales/pst/updateStockList.do", pstRequestDOForm, function(result) {
            
            Common.alert("PST info successfully updated");
            $("#editClose").click();
            fn_getStockEditListAjax();
          //resetUpdatedItems(); // 초기화
            
            console.log("PST info successfully updated.");
            console.log("data : " + result);
            
        },  function(jqXHR, textStatus, errorThrown) {
            try {
                console.log("status : " + jqXHR.status);
                console.log("code : " + jqXHR.responseJSON.code);
                console.log("message : " + jqXHR.responseJSON.message);
                console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
          }
          catch (e) {
              console.log(e);
              alert("Saving data prepration failed.");
          }

          alert("Fail : " + jqXHR.responseJSON.message);          
      });
    }
	
	// Add/Edit Address
	function fn_editAddrDtPop(){
		Common.popupDiv('/sales/pst/editAddrDtPop.do', $('#getParamForm').serializeJSON(), null , true, 'addrDtDiv');
	}
	
	// Select Another Address
	function fn_editAnotherAddrPop(){  
        Common.popupDiv('/sales/pst/pstAnotherAddrPop.do', $('#getParamForm').serializeJSON(), null , true, 'addrAnthDiv');
    }
	
	// Add/Edit Contact
    function fn_editContDtPop(){
        Common.popupDiv('/sales/pst/editContDtPop.do', $('#getParamForm').serializeJSON(), null , true, 'addrDtDiv');
    }
    
    // Select Another Contact
    function fn_editAnotherContPop(){  
        Common.popupDiv('/sales/pst/pstAnotherContPop.do', $('#getParamForm').serializeJSON(), null , true, 'addrAnthDiv');
    }
    
    function fn_getRate() {
    	if($("#curType").val() == 1148){
            $("#editCurRate").val($("#getRate").val());
        }else if($("#curType").val() == 1150){
            $("#editCurRate").val('1.00');
        }else if($("#curType").val() == 1149){
            $("#editCurRate").val('');
        }
    }

</script>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>PSO Info Edit</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#" id="editClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">PST Info</a></li>
    <li><a href="#">PST MailAddress</a></li>
    <li><a href="#">PST DeliveryAddress</a></li>
    <li><a href="#">PST MailContact</a></li>
    <li><a href="#">PST DeliveryContact</a></li>
    <li><a href="#" onclick="javascript: fn_resizefunc(editGridID)">PST StockList</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<aside class="title_line"><!-- title_line start -->
<h2>Customer Information</h2>
</aside><!-- title_line end -->

<form id="getParamForm" name="getParamForm" method="GET">
    <input type="hidden" id="pstSalesOrdId" name="pstSalesOrdId" value="${pstInfo.pstSalesOrdId}">
    <input type="hidden" id="editInchargeSelect" name="editInchargeSelect" value="${pstInfo.pic}">
    <input type="hidden" id="pstRefNo" name="pstRefNo" value="${pstInfo.pstRefNo}">
    <input type="hidden" id="dealerId" name="dealerId" value="${pstInfo.pstDealerId}">
    <input type="hidden" id="getRate" name="getRate" value="${getRate.rate}">
</form>
<form id="pstInfoForm" name="pstInfoForm" method="GET">
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
    <th scope="row">PSO ID</th>
    <td readOnly><span>${pstInfo.pstSalesOrdId}</span></td>
    <th scope="row">PSO RefNo</th>
    <td readOnly><span>${pstInfo.pstRefNo}</span></td>
    <th scope="row">Customer PO</th>
    <td readOnly><span>${pstInfo.pstCustPo}</span></td>
</tr>
<tr>
    <th scope="row">Currency Type</th>
    <td>
    <select id="curType" name="curType" class="w100p" onchange="fn_getRate()">
        <option value="1150">MYR</option>
        <option value="1149">SGD</option>
        <option value="1148">USD</option>
    </select>
    </td>
    <th scope="row">Currency Rate</th>
    <td><input type="text" title="" id="editCurRate" name="editCurRate" value="${pstInfo.pstCurRate}" placeholder="" class="w100p" /></td>
    <th scope="row">Person In Charge</th>
    <td>
        <select id="editIncharge" name="editIncharge" class="w100p">
        </select>
    </td>
</tr>
<tr>
    <th scope="row">PSO Status</th>
    <td readOnly><span>${pstInfo.pstStusCode}</span></td>
    <th scope="row">Create By</th>
    <td readOnly><span>${pstInfo.crtUserName}</span></td>
    <th scope="row">Create At</th>
    <td readOnly><span>${pstInfo.crtDt}</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5"><textarea id="editInfoRem" name="editInfoRem" cols="20" rows="5" readonly>${pstInfo.pstRem}</textarea></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue2"><a href="#" onclick="fn_editAddrDtPop()">Add/Edit Address</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="fn_editAnotherAddrPop()">Select Another Address</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2">Mailing Address</th>
    <td colspan="3"><span>${pstMailContact.AddrDtl}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${pstMailContact.street}</span></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td colspan="3"><span>${pstMailContact.Area}</span></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><span>${pstMailContact.city}</span></td>
    <th scope="row">Postcode</th>
    <td><span>${pstMailContact.postcode}</span></td>
</tr>
<tr>
    <th scope="row">State</th>
    <td><span>${pstMailContact.state}</span></td>
    <th scope="row">Country</th>
    <td><span>${pstMailContact.country}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue2"><a href="#" onclick="fn_editAddrDtPop()">Add/Edit Address</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="fn_editAnotherAddrPop()">Select Another Address</a></p></li>
</ul>

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row" rowspan="2">Delivery Address</th>
    <td colspan="3"><span>${pstDeliveryContact.AddrDtl}&nbsp;</span></td>
</tr>
<tr>
    <td colspan="3"><span>${pstDeliveryContact.street}&nbsp;</span></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td colspan="3"><span>${pstDeliveryContact.Area}</span></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><span>${pstDeliveryContact.city}</span></td>
    <th scope="row">Postcode</th>
    <td><span>${pstDeliveryContact.postcode}</span></td>
</tr>
<tr>
    <th scope="row">State</th>
    <td><span>${pstDeliveryContact.state}</span></td>
    <th scope="row">Country</th>
    <td><span>${pstDeliveryContact.country}</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue2"><a href="#" onclick="fn_editContDtPop()">Add/Edit Address</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="fn_editAnotherContPop()">Select Another Address</a></p></li>
</ul>

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
    <td><span>${pstMailContact.cntName }</span></td>
    <th scope="row">Initial</th>
    <td><span>${pstMailContact.dealerInitialCode }</span></td>
    <th scope="row">Gender</th>
    <td><span>${pstMailContact.gender }</span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>${pstMailContact.nric }</span></td>
    <th scope="row">Race</th>
    <td><span>${pstMailContact.raceName }</span></td>
    <th scope="row">Tel (Fax)</th>
    <td><span>${pstMailContact.telf }</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span>${pstMailContact.telM1 }</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>${pstMailContact.telR }</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${pstMailContact.telO }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<ul class="right_btns mb10">
    <li><p class="btn_blue2"><a href="#" onclick="fn_editContDtPop()">Add/Edit Address</a></p></li>
    <li><p class="btn_blue2"><a href="#" onclick="fn_editAnotherContPop()">Select Another Address</a></p></li>
</ul>

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
    <td><span>${pstDeliveryContact.cntName }</span></td>
    <th scope="row">Initial</th>
    <td><span>${pstDeliveryContact.dealerInitialCode }</span></td>
    <th scope="row">Gender</th>
    <td><span>${pstDeliveryContact.gender }</span></td>
</tr>
<tr>
    <th scope="row">NRIC</th>
    <td><span>${pstDeliveryContact.nric }</span></td>
    <th scope="row">Race</th>
    <td><span>${pstDeliveryContact.raceName }</span></td>
    <th scope="row">Tel (Fax)</th>
    <td><span>${pstDeliveryContact.telf }</span></td>
</tr>
<tr>
    <th scope="row">Tel (Mobile)</th>
    <td><span>${pstDeliveryContact.telM1 }</span></td>
    <th scope="row">Tel (Residence)</th>
    <td><span>${pstDeliveryContact.telR }</span></td>
    <th scope="row">Tel (Office)</th>
    <td><span>${pstDeliveryContact.telO }</span></td>
</tr>
</tbody>
</table><!-- table end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start 

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul>
-->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="stockEdit_grid_wrap" style="width:100%; height:250px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

<ul class="center_btns mt20">
    <li><p class="btn_blue2 big"><a href="#" onClick="javascript:fn_updateStockList();">Update Stock</a></p></li>
</ul>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->