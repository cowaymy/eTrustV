<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">

//AUIGrid 생성 후 반환 ID
var posGridID;
var deductionCmGridID;
var optionModule = {
        type: "S",                  
        isShowChoose: false  
};
var optionSystem = {
        type: "M",                  
        isShowChoose: false  
};

//Grid in SelectBox  - Selcet value
var arrStusCode;

$(document).ready(function() {

    
    fn_getStatusCode();
    createDeductionGrid();
    
     /*######################## Init Combo Box ########################*/
     
    //PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390, 2391, 2392]};
    CommonCombo.make('cmbPosTypeId', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);
    
    //PosSystemTypeComboBox
    var systemParam = {groupCode : 140 , codeIn : [1352, 1353 , 1361]};

    CommonCombo.make('cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionSystem);

    //selectStatusCodeList
    var statusParam = {groupCode : 9};
    CommonCombo.make('cmbStatusTypeId', "/sales/pos/selectStatusCodeList", statusParam , '', optionSystem);
    
    //branch List
    CommonCombo.make('cmbWhBrnchId', "/sales/pos/selectWhBrnchList", '' , '', '');
    
    //Wh List
    $("#cmbWhBrnchId").change(function() {
        
        var tempVal = $(this).val();
        if(tempVal == null || tempVal == '' ){
            $("#cmbWhId").val("");
        }else{
            var paramObj = {brnchId : tempVal};
            Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){
            	
            	if(result != null){
            		$("#cmbWhId").val(result.whLocDesc);	
            	}else{
            		$("#cmbWhId").val('');
            	}
            });
        }
    });
    
    /*######################## Init Combo Box ########################*/
    
    //cmbPosTypeId Change Func
    $("#cmbPosTypeId").change(function() {
        
        var tempVal = $(this).val();
        
        if(tempVal == 2392){
            var systemParam = {groupCode : 140 , codeIn : [1357]};
            var optionSystem = {
                    type: "M",                  
                    isShowChoose: false  
            };
            CommonCombo.make('cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionSystem);
        }else{
            var systemParam = {groupCode : 140 , codeIn : [1352, 1353 , 1361]};
            var optionSystem = {
                    type: "M",                  
                    isShowChoose: false  
            };
            CommonCombo.make('cmbSalesTypeId', "/sales/pos/selectPosModuleCodeList", systemParam , '', optionSystem);
        }
        
    });
    
    //Member Search Popup
    $('#memBtn').click(function() {
        Common.popupDiv("/common/memberPop.do", $("#searchForm").serializeJSON(), null, true);
    });

    $('#salesmanCd').change(function(event) {

        var memCd = $('#salesmanCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd);
        }
    });
    
    //Search
    $("#_search").click(function() {
        
        fn_getPosListAjax();
    });
    
    
    // 셀 더블클릭 이벤트 바인딩
    AUIGrid.bind(posGridID, "cellDoubleClick", function(event){
        
        alert("개발중...");
       /*  $("#_posNo").val(event.item.posNo);
        Common.popupDiv("/sales/pos/selectPosViewDetail.do", $("#detailForm").serializeJSON(), null , true , '123123'); */
        
    });
    
    //Pos System
    $("#_systemBtn").click(function() {
    	Common.popupDiv("/sales/pos/posSystemPop.do", '', null , true , '_insDiv');
    });
    
    //Pos Reversal
    $("#_reversalBtn").click(function() {
    	
    	var clickChk = AUIGrid.getSelectedItems(posGridID);
    	//Validation
    	if(clickChk == null || clickChk.length <= 0 ){
    		Common.alert("* No Order Selected. ");
    		return;
    	}
    	
    	if(clickChk[0].item.codeName1 == 1361){  //reversal
    		Common.alert("* Reversal POS are prohibited!");
    		return;
    	}
    	
    	// Invoice Chk
    	var reRefNo = clickChk[0].item.taxInvcRefNo;
    	var reObject = { reRefNo : reRefNo};
    	Common.ajax("GET", "/sales/pos/chkReveralBeforeReversal", reObject, function(result) {
    	    if(result != null){
    	    	Common.alert("* Reversal POS are prohibited!(invoice)");
                return;
    	    }			
		});
    	
    	//TODO payment 완료 후 추가 Validation 
    	// IsPaymentKnowOffByPOSNo
    	
    	
    	//TODO Check Auth
    	
    	//Call controller
    	var reversalForm = { posId : clickChk[0].item.posId };
    	Common.popupDiv("/sales/pos/posReversalPop.do", reversalForm , null , true , "_revDiv");
		
	});
    
});//Doc ready Func End

function createDeductionGrid () {
	 
	var posColumnLayout =  [ 
	                            {dataField : "posNo", headerText : "POS No.", width : '8%'}, 
	                            {dataField : "posDt", headerText : "Sales Date", width : '8%'},
	                            {dataField : "posDt", headerText : "Member ID", width : '8%'},
	                            {dataField : "codeName", headerText : "POS Type", width : '8%'},
	                            {dataField : "codeName1", headerText : "Sales Type", width : '8%'},
	                            {dataField : "taxInvcRefNo", headerText : "Invoice No.", width : '8%'}, 
	                            {dataField : "name", headerText : "Customer Name", width : '18%'},
	                            {dataField : "whLocCode", headerText : "Branch", width : '8%'},
	                            {dataField : "whLocCode", headerText : "Warehouse", width : '8%'},
	                            {dataField : "posTotAmt", headerText : "Total Amount", width : '8%'},
	                            {
	                                dataField : "stusId",
	                                headerText : "Status",
	                                width : '10%',
	                                labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
	                                    var retStr = "";
	                                    for(var i=0,len=arrStusCode.length; i<len; i++) {
	                                        if(arrStusCode[i]["codeId"] == value) {
	                                            retStr = arrStusCode[i]["codeName"];
	                                            break;
	                                        }
	                                    }
	                                                return retStr == "" ? value : retStr;
	                            },
	                                renderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
	                                       type : "DropDownListRenderer",
	                                       list : arrStusCode,
	                                       keyField   : "codeId", // key 에 해당되는 필드명
	                                       valueField : "codeName" // value 에 해당되는 필드명
	                                 }
	                           },
	                            {dataField : "posId", visible : false}
	                           ];
	    
	    //그리드 속성 설정
	    var gridPros = {
	            
	            usePaging           : true,         //페이징 사용
	            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
	            editable            : false,            
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
	    
	    deductionCmGridID = GridCommon.createAUIGrid("#deduc_grid_wrap", posColumnLayout,'', gridPros);  // address list
	    AUIGrid.resize(deductionCmGridID , 1660, 300);
}


//TODO 미개발 message
function fn_underDevelop(){
    Common.alert('The program is under development.');
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

function fn_getStatusCode(){
    
    $.ajax({
        type: 'get',
        url : getContextPath() + '/sales/pos/selectStatusCodeList',
        data : {groupCode : '9'},
        dataType : 'json',
        beforeSend: function (request) {
             // loading start....
             Common.showLoader();
         },
         complete: function (data) {
             // loading end....
             createAUIGrid();
             Common.removeLoader();
         },
         success: function(result) {
             
             var tempArr = new Array();
             
             for (var idx = 0; idx < result.length; idx++) {
                 tempArr.push(result[idx]); 
             }
             
             arrStusCode = tempArr;
             
        },error: function () {
            Common.alert("Fail to Get Code List....");
        }
        
    });
}


function fn_loadOrderSalesman(memId, memCode, isPop) {

    Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : memId, memCode : memCode}, function(memInfo) {

        if(memInfo == null) {
            Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
        }
        else {
            
        	if(isPop == 1){
        		$('#hiddenSalesmanPopId').val(memInfo.memId);
                $('#salesmanPopCd').val(memInfo.memCode);
               
                $('#salesmanPopCd').removeClass("readonly");	
        	}else{
        		$('#hiddenSalesmanId').val(memInfo.memId);
                $('#salesmanCd').val(memInfo.memCode);
               
                $('#salesmanCd').removeClass("readonly");
        	}
        	
          
        }
    });
}


function createAUIGrid(){
    
    
    var posColumnLayout =  [ 
                            {dataField : "posNo", headerText : "POS No.", width : '8%'}, 
                            {dataField : "posDt", headerText : "Sales Date", width : '8%'},
                            {dataField : "posDt", headerText : "Member ID", width : '8%'},
                            {dataField : "codeName", headerText : "POS Type", width : '8%'},
                            {dataField : "codeName1", headerText : "Sales Type", width : '8%'},
                            {dataField : "taxInvcRefNo", headerText : "Invoice No.", width : '8%'}, 
                            {dataField : "name", headerText : "Customer Name", width : '18%'},
                            {dataField : "whLocCode", headerText : "Branch", width : '8%' , style : 'left_style'},
                            {dataField : "whLocCode", headerText : "Warehouse", width : '8%'},
                            {dataField : "posTotAmt", headerText : "Total Amount", width : '8%'},
                            {
                                dataField : "stusId",
                                headerText : "Status",
                                width : '10%',
                                labelFunction : function( rowIndex, columnIndex, value, headerText, item) { 
                                    var retStr = "";
                                    for(var i=0,len=arrStusCode.length; i<len; i++) {
                                        if(arrStusCode[i]["codeId"] == value) {
                                            retStr = arrStusCode[i]["codeName"];
                                            break;
                                        }
                                    }
                                                return retStr == "" ? value : retStr;
                            },
                                renderer : { // 셀 자체에 드랍다운리스트 출력하고자 할 때
                                       type : "DropDownListRenderer",
                                       list : arrStusCode,
                                       keyField   : "codeId", // key 에 해당되는 필드명
                                       valueField : "codeName" // value 에 해당되는 필드명
                                 }
                           },
                            {dataField : "posId", visible : false}
                           ];
    
    //그리드 속성 설정
    var gridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
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
    
    posGridID = GridCommon.createAUIGrid("#pos_grid_wrap", posColumnLayout,'', gridPros);  // address list
    AUIGrid.resize(posGridID , 1660, 300);
}

function fn_getPosListAjax(){

      Common.ajax("GET", "/sales/pos/selectPosJsonList", $("#searchForm").serialize(), function(result) {
        
          AUIGrid.setGridData(posGridID, result);
      });
      
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

</script>
<div id="wrap"><!-- wrap start -->
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Point Of Sales</li>
    <li>POS</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>POS Listing</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" id="_search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#" onclick="javascript:$('#searchForm').clearForm();"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form  id="searchForm">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:170px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:170px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">POS Type</th>
    <td>
    <select class="w100p" id="cmbPosTypeId"  name="posModuleTypeId"></select>
    </td>
    <th scope="row">POS Sales Type</th>
    <td>
    <select class="w100p" id="cmbSalesTypeId" name="posTypeId" ></select>
    </td>
    <th scope="row">Status</th>
    <td>
        <select class="w100p" id="cmbStatusTypeId" name="posStatusId" ></select>
    </td>
</tr>
<tr>
    <th scope="row">POS Ref No.</th>
    <td>
    <input type="text" title="" placeholder="POS No." class="w100p"  name="posNo" />
    </td>
    <th scope="row">Sales Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="sDate"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="eDate" /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Member Code</th>
    <td>
        <input id="salesmanCd" name="salesmanCd" type="text" title="" placeholder="" class=""  style="width: 180px;"/>
        <input id="hiddenSalesmanId" name="salesmanId" type="hidden"  />
        <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row">Branch / Warehouse</th>
    <td colspan="3">
        <select  id="cmbWhBrnchId" ></select>
        <input type="text" disabled="disabled" id="cmbWhId" >
    </td>
    <th scope="row">Customer Name</th>
    <td>
    <input type="text" title="" placeholder="Customer Name" class="w100p" name="posCustName" />
    </td>
</tr>
<tr>
    <th scope="row">Member Name(Deduction)</th>
    <td>
        <input type="text" title="" placeholder="Member Name" class="w100p" />
    </td>
    <th scope="row">Member IC(Deduction)</th>
    <td colspan="3">
    <input type="text" title="" placeholder="Member IC" class="w100p" />
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#" onclick="javascript : fn_underDevelop()">POS Receipt</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#" onclick="javascript : fn_underDevelop()">POS Payment Listing</a></p></li>
        <li><p class="link_btn type2"><a href="#" onclick="javascript : fn_underDevelop()">POS Raw Data</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a  id="_systemBtn">POS System</a></p></li>
    <li><p class="btn_grid"><a  id="_reversalBtn">POS Reversal</a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h3>Result List</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="pos_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Save</a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h3>Deduction Member List</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="deduc_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Save</a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h3>Item List</h3>
</aside><!-- title_line end -->

<article class="grid_wrap"><!-- grid_wrap start -->
그리드 영역
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#">Save</a></p></li>
</ul>
</section><!-- search_result end -->
</section><!-- content end -->
<hr />
</div><!-- wrap end -->
