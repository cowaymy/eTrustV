<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script type="text/javascript">
//생성 후 반환 ID
var purchaseGridID;
var serialTempGridID;
var memGridID;

$(document).ready(function() {
	
	createPurchaseGridID();
	createSerialTempGridID();
	creatememGridID();
	
	//PosModuleTypeComboBox
	var modulePopParam = {groupCode : 143, codeIn : [2390, 2391]};
	CommonCombo.make('_insPosModuleType', "/sales/pos/selectPosModuleCodeList", modulePopParam , '', optionModule);
	
	//PosSystemTypeComboBox
    var systemPopParam = {groupCode : 140 , codeIn : [1352, 1353]};
    CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);
	
    //branch List
    var selVal = $("#_memBrnch").val().trim();
   // console.log('membrnch : [' + selVal+ ']');
    CommonCombo.make('_cmbWhBrnchIdPop', "/sales/pos/selectWhBrnchList", '' , selVal.trim(), '');
    
    //Wh List
    $("#_cmbWhBrnchIdPop").change(function() {
    	getLocIdByBrnchId($(this).val());
    });
    
    //_insPosModuleType Change Func
    $("#_insPosModuleType").change(function() {
        
        var tempVal = $(this).val();
        
        if(tempVal == 2390){ //POS Sales
            var optionSystem = {
                    type: "M",                  
                    isShowChoose: false  
            };
            var systemPopParam = {groupCode : 140 , codeIn : [1352, 1353]};
            CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);
            //MEM GRID DISPLAY
            $("#_purchMemBtn").css("display" , "none");
            $("#_mainMemberGrid").css("display" , "none");
            
            //SERIAL GRID DISPLAY
            $("#_mainSerialGrid").css("display" , "none");
            
            fn_clearAllGrid();
        }
        
        if(tempVal == 2391){ //Deduction
        	 var optionSystem = {
                     type: "M",                  
                     isShowChoose: false  
             };
             var systemPopParam = {groupCode : 140 , codeIn : [1352, 1353]};
             CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);
             //MEM GRID DISPLAY
             $("#_purchMemBtn").css("display" , "");
             $("#_mainMemberGrid").css("display" , "");
             
             //SERIAL GRID DISPLAY
             $("#_mainSerialGrid").css("display" , "none");
             
             fn_clearAllGrid();
        }
        
       /*  if(tempVal == 2392){ //Other Income
            var optionSystem = {
                    type: "M",                  
                    isShowChoose: false  
            };
            var systemPopParam = {groupCode : 140 , codeIn : [1358]};
            CommonCombo.make('_insPosSystemType', "/sales/pos/selectPosModuleCodeList", systemPopParam , '', optionModule);
             //MEM GRID DISPLAY
            $("#_purchMemBtn").css("display" , "none");
            $("#_mainMemberGrid").css("display" , "none");
            
            //SERIAL GRID DISPLAY
            $("#_mainSerialGrid").css("display" , "none");
            
            fn_clearAllGrid();
       } */
        
    });
    
    $("#_insPosSystemType").change(function() {
		
    	//clear Grid
    	fn_clearAllGrid();
    	
    	//
    	$("#_mainSerialGrid").css("display" , "none");
    	
	});
    
    //Member Search Popup
    $('#memBtnPop').click(function() {
        var callParam = {callPrgm : "1"};
    	Common.popupDiv("/common/memberPop.do", callParam, null, true);
    });
    
    $('#salesmanPopCd').change(function(event) {

        var memCd = $('#salesmanPopCd').val().trim();

        if(FormUtil.isNotEmpty(memCd)) {
            fn_loadOrderSalesman(0, memCd, 1);
        }
    });
    
    $("#_purcDelBtn").click(function() {
        
        //1. basketGrid == cheked Items
        var chkDelArray = AUIGrid.getCheckedRowItems(purchaseGridID);
        //2. serialGrid == all Items
        var serialItemArray  = AUIGrid.getColumnValues(serialTempGridID, 'matnr');
        //3. Serial Check
        var delArr = [];
        for (var idx = 0; idx < chkDelArray.length; idx++) {
            for (var i = 0; i < serialItemArray.length; i++) {
                if(chkDelArray[idx].item.stkCode == serialItemArray[i]){
                    delArr.push(i);
                }
            }
        }
        //4. Delete Serial Number
        if(delArr != null && delArr.length > 0){
            AUIGrid.removeRow(serialTempGridID, delArr); 
        }
        
        var serialRowCnt = AUIGrid.getRowCount(serialTempGridID);
        if(serialRowCnt <= 0){
        	$("#_mainSerialGrid").css("display" , "none");
        }
        //5. Remove Check Low 
        AUIGrid.removeCheckedRows(purchaseGridID);
    });
    
    //Purchase Btn
    $("#_purchBtn").click(function() {
		
    	//Pos Sales  AND Deduction
    	if($("#_insPosModuleType").val() == 2390 || $("#_insPosModuleType").val() == 2391) { 
			
    		if($("#_insPosSystemType").val() == 1352){ //Pos Filter / Spare Part / Miscellaneous
    			
    			// 창고 Validation
    			if($("#_cmbWhBrnchIdPop").val() == null || $("#_cmbWhBrnchIdPop").val() == ''){
    				Common.alert('* please Select Warehouse`s Branch.');
    				return;
    			}
    			if($("#_hidLocId").val() == null || $("#_hidLocId").val() == ''){
    				Common.alert('* Warehouse`s Branch has no Location Id.');
                    return;
    			}
    			//창고 parameter
    		//	$("#_cmbWhBrnchIdPop").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    			Common.popupDiv("/sales/pos/posItmSrchPop.do", $("#_sysForm").serializeJSON(), null, true);
    		} 
    	
    	    if($("#_insPosSystemType").val() == 1353){ // Pos Item Bank
    	    //	$("#_cmbWhBrnchIdPop").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    	    	Common.popupDiv("/sales/pos/posItmSrchPop.do", $("#_sysForm").serializeJSON(), null, true);
    	    	
            }
    		   		
		}
    	
    	//Other Income - Item Bank(HQ)
    	if($("#_insPosModuleType").val() == 2392) { 
    		
    		if($("#_insPosSystemType").val() == 1358){ //Item Bank(HQ)
    			
    		    // 창고 Validation
                if($("#_cmbWhBrnchIdPop").val() == null || $("#_cmbWhBrnchIdPop").val() == ''){
                    Common.alert('* please Select Warehouse`s Branch.');
                    return;
                }
                if($("#_hidLocId").val() == null || $("#_hidLocId").val() == ''){
                    Common.alert('* Warehouse`s Branch has no Location Id.');
                    return;
                }
                //창고 parameter
            //  $("#_cmbWhBrnchIdPop").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
                Common.popupDiv("/sales/pos/posItmSrchPop.do", $("#_sysForm").serializeJSON(), null, true);
    		}
    	}
	});
    
    
    //Save Request
    $("#_posReqSaveBtn").click(function() {
    	
    	/****Validation ***/
    	//Purchase Grid Null Check
    	if(AUIGrid.getGridData(purchaseGridID) <= 0){
    		Common.alert("* Please select the Item(s). ");
    		return;
    	}
    	
    	//Member Grid Null Check
    	if($("#_insPosModuleType").val() == 2391){
    		if(AUIGrid.getGridData(memGridID) <= 0){
                Common.alert("* Please select the Member(s). ");
                return;
            }	
    	}
    	
    	//Member Code and Id Null Check
    	if(null == $("#salesmanPopCd").val() || '' == $("#salesmanPopCd").val()){
    		Common.alert("* Please select the member code.");
    		return;
    	}
    	//Member Check
    	var ajaxOption = {
            async: false,
            isShowLoader : true
        };
    	Common.ajax("GET", "/sales/order/selectMemberByMemberIDCode.do", {memId : $("#hiddenSalesmanPopId").val(), memCode : $("#salesmanPopCd").val()}, function(memInfo) {
            if(memInfo == null) {
                Common.alert('<b>Member not found.</br>Your input member code : '+memCode+'</b>');
                return;
            }
        },null,ajaxOption);
    	//Branch WareHouse Null Check
    	if( null == $("#_cmbWhBrnchIdPop").val() || '' == $("#_cmbWhBrnchIdPop").val()){
    		Common.alert("* Please select the warehouse. ");
    		return;
    	}
    	//Receive Date Null Check
    	if( null == $("#_recvDate").val() || '' == $("#_recvDate").val()){
    		Common.alert("* Please select the Receive date.");
    		return;
    	}
    	// Compare with Todaty?
    	
    	//Remark Null Check
    	if( null == $("#_posRemark").val() || '' == $("#_posRemark").val()){
    		Common.alert(" * Please key in Remark. ");
    		return;
    	}
    	
    	//TODO payment not Enter
    	/*###############  Payment Validation Part #################################*/
    	
    	if($("#_insPosModuleType").val() == 2390){   //POS SALES
    		//Save
            Common.confirm("Will you proceed with payment?", fn_payProceed, fn_payPass);
    		
    	}else{ //Deduction , Other Income
    		//Save
    		fn_payPass();
    		
    	}
    	/*###############  Payment Validation Part #################################*/
    	
		//, (), ()
	});
    
    //Member List
    $("#_purchMemBtn").click(function() {
    	
    	
    	if(null == $("#_cmbWhBrnchIdPop").val() || '' == $("#_cmbWhBrnchIdPop").val()){
    		Common.alert("* Please select Warehouse first.");
    		return;
    	}
    	
    	Common.popupDiv("/sales/pos/posMemUploadPop.do", $("#_sysForm").serializeJSON(), null , true , '_memDiv');
	});
    
});//Document Ready Func End

function fn_clearAllGrid(){
    
    AUIGrid.clearGridData(purchaseGridID);  //purchase TempGridID
    AUIGrid.resize(purchaseGridID , 960, 300);
    
    AUIGrid.clearGridData(memGridID);  //member TempGridID
    AUIGrid.resize(memGridID , 960, 300);
     
    AUIGrid.clearGridData(serialTempGridID);  //serial TempGridID
    AUIGrid.resize(serialTempGridID , 960, 300);
    
}

function fn_setMemberGirdData(paramObj){
	
	AUIGrid.setGridData(memGridID, paramObj);
	
}


function fn_payPass(){
	
	 var data = {};
     var prchParam = AUIGrid.getGridData(purchaseGridID);
     var serialParam = AUIGrid.getGridData(serialTempGridID);
     var memParam = AUIGrid.getGridData(memGridID);
     
     data.prch = prchParam;
     data.serial = serialParam;
     data.mem = memParam;
	 $("#_payResult").val('-1'); //payment
     data.form = $("#_sysForm").serializeJSON();
	 
     Common.ajax("POST", "/sales/pos/insertPos.do", data,function(result){
         Common.alert("POS saved. <br /> POS Ref No. :  [" + result.reqDocNo + "]" , fn_popClose()); 
     });
	
}

function fn_payProceed(){
	var data = {};
    var prchParam = AUIGrid.getGridData(purchaseGridID);
    var serialParam = AUIGrid.getGridData(serialTempGridID);
    var memParam = AUIGrid.getGridData(memGridID);
    
    data.prch = prchParam;
    data.serial = serialParam;
    data.mem = memParam;
    $("#_payResult").val('1');  //payment 
    data.form = $("#_sysForm").serializeJSON();
    
    Common.ajax("POST", "/sales/pos/insertPos.do", data,function(result){
    	
    	Common.alert("POS saved. <br /> POS Ref No. :  [" + result.reqDocNo + "]" , fn_bookingAndpopClose()); 
    });
}

//Close
function fn_popClose(){
	$("#_systemClose").click();
}

function fn_bookingAndpopClose(){
    //프로시저 호출
	// 콜백  >> 
	$("#_systemClose").click();
}


function getLocIdByBrnchId(tempVal) {
	  
   /*  var tempVal = $(this).val(); */
    if(tempVal == null || tempVal == '' ){
        $("#cmbWhIdPop").val("");
    }else{
        var paramObj = {brnchId : tempVal};
        Common.ajax('GET', "/sales/pos/selectWarehouse", paramObj,function(result){
            
            if(result != null){
                
            	console.log("result.whLocId : " + result.whLocId);
            	
            	$("#cmbWhIdPop").val(result.whLocDesc);
                $("#_hidLocId").val(result.whLocId); 
            }else{
                $("#cmbWhIdPop").val('');
                $("#_hidLocId").val(''); 
            }
        });
    }
}

function createPurchaseGridID(){
    
    
    var posColumnLayout =  [ 
                            {dataField : "stkCode", headerText : "Item Code", width : '10%'}, 
                            {dataField : "stkDesc", headerText : "Item Description", width : '30%'},
                            {dataField : "qty", headerText : "Inv.Stock", width : '10%'},
                            {dataField : "inputQty", headerText : "Qyt", width : '10%'},
                            {dataField : "amt", headerText : "Unit Price", width : '10%' , dataType : "numeric", formatString : "#,##0.00"}, 
                            {dataField : "subTotal", headerText : "Sub Total(Exclude GST)", width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                            	var calObj = fn_calculateAmt(item.amt , item.inputQty);
                            	return Number(calObj.subChanges); 
							}},
                            {dataField : "subChng", headerText : "GST(6%)", width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                            	var calObj = fn_calculateAmt(item.amt , item.inputQty);
                                return Number(calObj.taxes);
                            }},
                            {dataField : "totalAmt", headerText : "Total Amount", width : '10%', dataType : "numeric", formatString : "#,##0.00", expFunction : function(rowIndex, columnIndex, item, dataField ) {
                            	var calObj = fn_calculateAmt(item.amt , item.inputQty);
                            	return Number(calObj.subTotal);
                            }},
                            {dataField : "stkTypeId" , visible :false},
                            {dataField : "stkId" , visible :false}//STK_ID
                           ];
    
    //그리드 속성 설정
    var gridPros = {
            showFooter : true,
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
            showRowCheckColumn : true, //checkBox
            softRemoveRowMode : false,
            noDataMessage       : "No Item found.",
            groupingMessage     : "Here groupping"
    };
    
    purchaseGridID = GridCommon.createAUIGrid("#item_grid_wrap", posColumnLayout,'', gridPros);  // address list
    AUIGrid.resize(purchaseGridID , 960, 300);
    
    //
    var footerLayout = [ {
        labelText : "Total(RM)",
        positionField : "#base"
      },{
        dataField : "subTotal",
        positionField : "subTotal",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
      }, {
        dataField : "subChng",
        positionField : "subChng",
        operation : "SUM",
        formatString : "#,##0.00",
        style : "aui-grid-my-footer-sum-total2"
       },{
           dataField : "totalAmt",
           positionField : "totalAmt",
           operation : "SUM",
           formatString : "#,##0.00",
           style : "aui-grid-my-footer-sum-total2"
      }];
//
   // 푸터 레이아웃 그리드에 설정
   AUIGrid.setFooter(purchaseGridID, footerLayout);
}

function createSerialTempGridID(){
    
    
var serialGridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            softRemoveRowMode : false,
            showRowCheckColumn : false, //checkBox
            noDataMessage       : "No Item found.",
            groupingMessage     : "Here groupping"
    };
    
  var serialConfirmlColumnLayout =  [ 
                             {dataField : "matnr", headerText : "Filter Code", width : '33%' , editable : false  } ,
                             {dataField : "stkDesc", headerText : "Filter Name", width : '33%' , editable : false },
                             {dataField : "serialNo", headerText : "Serial", width : '33%' , editable : false } 
                            ];
    
    serialTempGridID = GridCommon.createAUIGrid("#serialTemp_grid_wrap", serialConfirmlColumnLayout,'', serialGridPros);
    AUIGrid.resize(serialTempGridID , 960, 300);
}


function creatememGridID(){

	var memGridPros = {
            
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            fixedColumnCount    : 1,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : true,         //줄번호 칼럼 렌더러 출력
            softRemoveRowMode : false,
            showRowCheckColumn : false, //checkBox
            noDataMessage       : "No Item found.",
            groupingMessage     : "Here groupping"
    };
	
	var memConfirmlColumnLayout =  [ 
	                                     {dataField : "memId" , headerText : "Member ID", width : "20%",  editable : false },
		                                 {dataField : "memCode" , headerText : "Member Code", width : "20%",  editable : false },
		                                 {dataField : "name" , headerText : "Member NAme", width : "20%",  editable : false },
		                                 {dataField : "nric" , headerText : "Member NRIC", width : "20%",  editable : false },
		                                 {dataField : "code" , headerText : "Branch", width : "20%",  editable : false },
		                                 {dataField : "brnch" , visible : false},
		                                 {dataField : "memType" , visible : false},
		                                 {dataField : "fullName" , visible : false},
		                                 {dataField : "stus" , visible : false}
	                                 ];
	
	memGridID = GridCommon.createAUIGrid("#memTemp_grid_wrap", memConfirmlColumnLayout,'', memGridPros);
}

//posItmSrchPop -> posSystemPop
function getItemListFromSrchPop(itmList, serialList){
	AUIGrid.setGridData(purchaseGridID, itmList);
	AUIGrid.setGridData(serialTempGridID, serialList);
}

function fn_calculateAmt(amt, qty) {
    
    var subTotal = 0;
    var subChanges = 0;
    var taxes = 0;
    
    subTotal = amt * qty;
    subChanges = (subTotal * 100) / 106;
    subChanges = subChanges.toFixed(2); //소수점2반올림
    taxes = subTotal - subChanges;
    taxes = taxes.toFixed(2);
    
    var retObj = {subTotal : subTotal , subChanges : subChanges , taxes : taxes};
    
    return retObj;
    
}

</script>
<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->
<input type="hidden" id="_memBrnch" value="${memCodeMap.brnch}">


<header class="pop_header"><!-- pop_header start -->
<h1>POS Request</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a id="_systemClose">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<ul class="right_btns">
    <li><p class="btn_blue2"><a id="_purchBtn">Purchase Items</a></p></li>
    <li><p class="btn_blue2" ><a id="_purchMemBtn" style="display: none;">Member List</a></p></li>
    <li><p class="btn_blue2"><a id="_posReqSaveBtn">Save</a></p></li>
</ul>

<aside class="title_line"><!-- title_line start -->
<h2>POS Information</h2>
</aside><!-- title_line end -->
<form id="_sysForm">
<!-- HIDDEN VALUES -->
<input type="hidden" name="hidLocId" id="_hidLocId" value="${locMap.whLocId }">
<input type="hidden" name="posReason" id="_posReason">  
<input type="hidden" name="payResult" id="_payResult">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">POS Type</th>
    <td>
    <select class="w100p" id="_insPosModuleType" name="insPosModuleType"></select>
    </td>
    <th scope="row">POS Sales Type</th>
    <td>
    <select class="w100p" id="_insPosSystemType" name="insPosSystemType"></select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Particular Information</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Code</th>
    <td> 
        <input id="salesmanPopCd" name="salesmanPopCd" type="text" title="" placeholder="" class=""  value="${memCodeMap.memCode}"/>
        <input id="hiddenSalesmanPopId" name="salesmanPopId" type="hidden"  value="${memCodeMap.memId}"/>
        <a id="memBtnPop" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </td>
</tr>
<tr>
    <th scope="row">Branch / Warehouse</th>
    <td>
         <select  id="_cmbWhBrnchIdPop" name="cmbWhBrnchIdPop"></select>
        <input type="text" disabled="disabled" id="cmbWhIdPop"  value="${locMap.whLocDesc}">
    </td>
</tr>
<tr>
    <th scope="row">Receive Date</th>
    <td>
        <input type="text" title="기준년월" class="j_date w100p" placeholder="MM/YYYY" readonly="readonly"  id="_recvDate" name="recvDate"/>
    </td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td>
        <input type="text" title="" placeholder="" class="w100p" id="_posRemark" name="posRemark" />
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<aside class="title_line"><!-- title_line start -->
<h2>Charges Balance</h2>
</aside><!-- title_line end -->

<ul class="right_btns">
    <!-- <li><p class="btn_grid"><a id="_purchBtn">Purchase Items</a></p></li>
    <li><p class="btn_grid" ><a id="_purchMemBtn" style="display: none;">Member List</a></p></li> -->
    <li><p class="btn_grid"><a id="_purcDelBtn">DEL</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="item_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<div id="_mainSerialGrid" style="display: none;"> 
<aside class="title_line"><!-- title_line start -->
<h2>Serial List</h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="serialTemp_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div> 
</article>
</div>

<div id="_mainMemberGrid" style="display: none;">
<aside class="title_line"><!-- title_line start -->
<h2>Member List</h2>
</aside><!-- title_line end -->
<article class="grid_wrap"><!-- grid_wrap start -->
<div id="memTemp_grid_wrap" style="width:100%; height:300px; margin:0 auto;"></div>
</article>
</div>

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->