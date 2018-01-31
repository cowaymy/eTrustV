<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//AUIGrid 생성 후 반환  ID
var calGrid;

//Window Option
var option = {
        width: "1000px", // 창 가로 크기
        height: "520px" // 창 세로 크기
         }
$(document).ready(function() {
	
	createCalGrid();   
	
	doGetCombo('/sales/ccp/getBranchCodeList', '', '','_keyInBranch', 'M' , 'f_multiCombo'); //Branch
	doGetCombo('/sales/ccp/selectDscCodeList', '', '','_keyInDscBranch', 'S' , 'f_multiCombo'); //Branch
	
	//doGetProductCombo('/common/selectProductCodeList.do', '', '', 'listProductId', 'S'); //Product Code
	doGetComboWh('/sales/order/colorGridProductList.do', '', '', 'listProductId', '', ''); //Product Code
	
	doGetCombo('/common/selectCodeList.do', '51', '',  '_calCcpType', 'S'); // CCP Type Id
	doGetCombo('/common/selectCodeList.do', '53', '',  '_calScheme', 'S'); // Scheme Type Id
	doGetCombo('/sales/ccp/selectReasonCodeFbList', '', '','_reasonCode', 'M' , 'f_multiCombo'); //Reason
	
	//Search
	$("#_calSearch").click(function() {
		
		Common.ajax("GET", "/sales/ccp/selectCalCcpListAjax", $("#_searchForm").serialize(), function(result) {
			   AUIGrid.setGridData(calGrid, result); 
		   });
	});
	
	
	//Edit
	 // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(calGrid, "cellDoubleClick", function(event){
    	
    	if('${PAGE_AUTH.funcChange}' == 'Y'){
    		if(event.item.ccpStusId == 1){
                $("#_ccpId").val(event.item.ccpId);
                $("#_salesOrdId").val(event.item.salesOrdId);
                $("#_ccpTotScrePoint").val(event.item.ccpTotScrePoint);
                //Common.popupDiv("/sales/ccp/selectCalCcpViewEditPop.do", $("#_detailForm").serializeJSON(), null , true , '_viewEditDiv'); //Edit
               
                Common.popupWin('_detailForm', "/sales/ccp/selectCalCcpViewEditPop.do", option);
                
            }else{
                $("#_ccpId").val(event.item.ccpId);
                $("#_salesOrdId").val(event.item.salesOrdId);
                $("#_ccpTotScrePoint").val(event.item.ccpTotScrePoint);
                //Common.popupDiv("/sales/ccp/ccpCalCCpViewPop.do", $("#_detailForm").serializeJSON(), null , true , '_viewDiv'); //View
                
                Common.popupWin('_detailForm', "/sales/ccp/ccpCalCCpViewPop.do", option);
            }
    	}else{
    		Common.alert('<spring:message code="sal.alert.msg.accessDeny" />');
    	}
    });
	
	//Update Pay Channel (_updPayBtn)############################### Pay
	$("#_updPayBtn").click(function() {
		//Validation 
		var selectedItem = AUIGrid.getSelectedItems(calGrid);
		if(selectedItem.length <= 0){
			Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
            return;
		}
		
		if(selectedItem[0].item.ccpStusId != 1){
			Common.alert('<spring:message code="sal.alert.msg.ccpStusIsNotAct" />');
			return;
		}
		
		//PopUp
		$("#_salesOrdId").val(selectedItem[0].item.salesOrdId);
        Common.popupDiv("/sales/order/orderRentPaySetLimitPop.do", $("#_detailForm").serializeJSON(), null , true , '_editDiv');
	});
	
	//Update Cust Limit Info  (_updCustBtn)  ######################## Cust
	$("#_updCustBtn").click(function() {
        //Validation 
        var selectedItem = AUIGrid.getSelectedItems(calGrid);
        if(selectedItem.length <= 0){
            Common.alert('<spring:message code="sal.alert.msg.noResultSelected" />');
            return;
        }
        
        if(selectedItem[0].item.ccpStusId != 1){
            Common.alert('<spring:message code="sal.alert.msg.ccpStusIsNotAct" />');
            return;
        }
        
        //PopUp
        $("#_custId").val(selectedItem[0].item.custId);
        Common.popupDiv("/sales/customer/updateCustomerBasicInfoLimitPop.do", $("#_detailForm").serializeJSON(), null , true , '_editDiv6');
    });
	
});//Doc Ready Func End

//def Combo(select Box OptGrouping)
function doGetComboWh(url, groupCd , selCode, obj , type, callbackFn){
  
  $.ajax({
      type : "GET",
      url : url,
      data : { groupCode : groupCd},
      dataType : "json",
      contentType : "application/json;charset=UTF-8",
      success : function(data) {
         var rData = data;
         Common.showLoader(); 
         fn_otpGrouping(rData, obj)
      },
      error: function(jqXHR, textStatus, errorThrown){
          alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
      },
      complete: function(){
          Common.removeLoader();
      }
  }); 
} ;

function fn_otpGrouping(data, obj){

   var targetObj = document.getElementById(obj);
   
   for(var i=targetObj.length-1; i>=0; i--) {
          targetObj.remove( i );
   }
   
   obj= '#'+obj;
   
   // grouping
   var count = 0;
   $.each(data, function(index, value){
       
       if(index == 0){
          $("<option />", {value: "", text: 'Choose One'}).appendTo(obj);
       }
       
       if(index > 0 && index != data.length){
           if(data[index].groupCd != data[index -1].groupCd){
               $(obj).append('</optgroup>');
               count = 0;
           }
       }
       
       if(data[index].codeId == null  && count == 0){
           $(obj).append('<optgroup label="">');
           count++;
       }
       if(data[index].codeId == 736 && count == 0){
           $(obj).append('<optgroup label="Air Purifier">');
           count++;
       }
       if(data[index].codeId == 110  && count == 0){
           $(obj).append('<optgroup label="Bidet">');
           count++;
       }
       if(data[index].codeId == 790 && count == 0){
           $(obj).append('<optgroup label="Juicer">');
           count++;
       }
       //
       if(data[index].codeId == 856 && count == 0){
           $(obj).append('<optgroup label="Point Of Entry ">');
           count++;
       }
       if(data[index].codeId == 538 && count == 0){
           $(obj).append('<optgroup label="Softener ">');
           count++;
       }
       if(data[index].codeId == 217 && count == 0){
           $(obj).append('<optgroup label="Water Purifier ">');
           count++;
       }

       $('<option />', {value : data[index].codeId, text: data[index].codeName}).appendTo(obj); // WH_LOC_ID
       
       
       if(index == data.length){
           $(obj).append('</optgroup>');
       }
   });
   //optgroup CSS
   $("optgroup").attr("class" , "optgroup_text");
   
}

$.fn.clearForm = function() {
    return this.each(function() {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag === 'form'){
            return $(':input',this).clearForm();
        }
        if (type === 'text' || type === 'password' || type === 'hidden' || tag === 'textarea'){
            this.value = '';
        }else if (type === 'checkbox' || type === 'radio'){
            this.checked = false;
        }else if (tag === 'select'){
            this.selectedIndex = -1;
        }
    });
};

function createCalGrid(){
	
	var  columnLayout = [
	                     {dataField : "salesOrdNo", headerText : '<spring:message code="sal.title.text.ordBrNo" />', width : "7%" , editable : false},
	                     {dataField : "ccpIsHold", headerText : '<spring:message code="sal.title.text.hold" />', width : "4%" , editable : false,
	                       renderer : {type : "CheckBoxEditRenderer", editable : false , checkValue : true , unCheckValue : false}
	                     },
	                     {dataField : "refNo", headerText :'<spring:message code="sal.title.text.ordBrRefNo" />', width : "7%" , editable : false},
	                     {dataField : "name1", headerText : '<spring:message code="sal.text.branch" />', width : "7%" , editable : false},
	                     {dataField : "keyAt", headerText : '<spring:message code="sal.title.text.keyAtBrBy" />', width : "10%" , editable : false},
	                     {dataField : "name", headerText : '<spring:message code="sal.title.text.customerName" />', width : "9%" , editable : false},
	                     {dataField : "ccpTotScrePoint", headerText : '<spring:message code="sal.title.text.totBrPoint" />', width : "7%" , editable : false},
	                     {dataField : "ccpStatus", headerText : '<spring:message code="sal.title.text.ccpBrStus" />', width : "7%" , editable : false},
	                     {dataField : "name2", headerText : '<spring:message code="sal.title.text.ccpBrRjtBrStus" />', width : "7%" , editable : false},
	                     {dataField : "ccpRem", headerText : '<spring:message code="sal.title.text.ccpBrRem" />', width : "15%" , editable : false},
	                     {dataField : "resnDesc", headerText : '<spring:message code="sal.title.text.specialBrRem" />', width : "10%" , editable : false},
	                     {dataField : "updAt", headerText : '<spring:message code="sal.title.text.lastBrUpdAtBrBy" />', width : "10%" , editable : false},
	                     {dataField : "ccpId", visible : false},
	                     {dataField : "salesOrdId", visible : false},
	                     {dataField : "ccpStusId", visible : false}, 
	                     {dataField : "ccpTotScrePoint", visible : false},
	                     {dataField : "custId", visible : false}
	                     
	]
	
	//그리드 속성 설정
    var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 20,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
//            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 60,
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력    
            wordWrap :  true
        };
	
	calGrid = GridCommon.createAUIGrid("cal_grid_wrap", columnLayout,'', gridPros);
	
}

// 조회조건 combo box
function f_multiCombo(){
    $(function() {
        $('#_keyInBranch').change(function() {
        
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '80%'
        });
        $('#_reasonCode').change(function() {
            
        }).multipleSelect({
            selectAll: true, // 전체선택 
            width: '80%'
        });
       
    });
}

//TODO 미개발
function fn_underDevelop(){
    Common.alert('The program is under development.');
}

function popup(location){
    if(location == "listing"){
        Common.popupDiv("/sales/ccp/ccpCalListingPop.do", $("#_searchForm").serializeJSON(), null, true); 
    }else if(location == 'rawData'){
    	Common.popupDiv("/sales/ccp/ccpCalRawDataPop.do", $("#_searchForm").serializeJSON(), null, true); 
    }else if(location == 'performance'){
    	Common.popupDiv("/sales/ccp/ccpCalPerformancePop.do", $("#_searchForm").serializeJSON(), null, true);
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
<h2><spring:message code="sal.title.text.custCredibPtList" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_blue type2"><a id="_updPayBtn"><spring:message code="sal.title.text.updPayChnnl" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcUserDefine2 == 'Y'}"> 
    <li><p class="btn_blue type2"><a id="_updCustBtn"><spring:message code="sal.title.text.updCustInfo" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue type2"><a id="_calSearch"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue type2"><a href="#" onclick="javascript:$('#_searchForm').clearForm();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->
<form id="_detailForm">
    <input type="hidden" name="ccpId" id="_ccpId">
    <input type="hidden" name="salesOrdId" id="_salesOrdId">
    <input type="hidden" name="ccpTotScrePoint" id="_ccpTotScrePoint">
    <input type="hidden" name="custId" id="_custId">
    
    <input type="hidden" name="useDisable" value="1">
    
</form>

<section class="search_table"><!-- search_table start -->
<form id="_searchForm">

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
    <th scope="row"><spring:message code="sal.text.ordNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="calOrdNo"/></td>
    <th scope="row"><spring:message code="sal.text.ordDate" /></th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date" name="calStartDate"/></p>
    <span><spring:message code="sal.title.to" /></span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date"  name="calEndDate"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"><spring:message code="sal.title.text.ccpStatus" /><span class="must">*</span></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="calCcpStatus">
        <option value="1" selected="selected"><spring:message code="sal.btn.active" /></option>
        <option value="5" selected="selected"><spring:message code="sal.combo.text.approv" /></option>
        <option value="4" selected="selected"><spring:message code="sal.combo.text.rej" /></option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.branch" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" name="calBranch" id="_keyInBranch"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.dscBrnch" /></th>
    <td>
    <select class="w100p" name="calDscBranch" id="_keyInDscBranch"></select>
    </td>
    <th scope="row"><spring:message code="sal.text.custName" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="calCustName"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.nricCompNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="calNric"/></td>
    <th scope="row"><spring:message code="sal.title.text.actionPoint" /></th>
    <td>
    <select class="w100p" name="calActPoint">
        <option value=""><spring:message code="sal.combo.text.chooseOne" /></option>
        <option value="1"><spring:message code="sal.title.text.noActionPoint" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.product" /></th>
    <td>
    <select class="w100p" id="listProductId" name="calProductId"></select>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.ccpType" /></th>
    <td>
    <select class="w100p" name="calCcpType" id="_calCcpType"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.schemeType" /></th>
    <td>
    <select class="w100p" name="calScheme" id="_calScheme"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.ordRefNo" /></th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="calOrdRefNo"/></td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.title.text.region" /></th>
    <td>
    <select class="w100p" name="calRegion" id="_calRegion">
        <option value=""><spring:message code="sal.combo.text.chooseOne" /></option>
        <option value="651"><spring:message code="sal.combo.text.central" /></option>
        <option value="652"><spring:message code="sal.combo.text.northern" /></option>
        <option value="654"><spring:message code="sal.combo.text.centralA" /></option>
        <option value="655"><spring:message code="sal.combo.text.centralB" /></option>
    </select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.ccpFbCode" /></th>
    <td>
    <select class="multy_select w100p" multiple="multiple" id="_reasonCode" name="calReason"></select>
    </td>
    <th scope="row"><spring:message code="sal.title.text.lastUpdUser" /></th>
    <td><input type="text" title="" placeholder="" class="w100p" name="calUpdator"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt><spring:message code="sal.title.text.link" /></dt>
    <dd>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn"><a href="#" onclick="javascript : popup('listing')"><spring:message code="sal.title.text.listing" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn"><a href="#" onclick="javascript : popup('rawData')"><spring:message code="sal.title.text.rawData" /></a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine3 == 'Y'}">
        <li><p class="link_btn"><a href="#" onclick="javascript : popup('performance')"><spring:message code="sal.title.text.perfomance" /></a></p></li>
        </c:if>
    </ul>
    <ul class="btns">
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<!-- <ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a href="#">INS</a></p></li>
    <li><p class="btn_grid"><a href="#">ADD</a></p></li>
</ul> -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="cal_grid_wrap" style="width:100%; height:480px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->
</body>
</html>