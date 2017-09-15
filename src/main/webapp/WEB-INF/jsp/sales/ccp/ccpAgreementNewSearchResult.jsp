<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javascript">
    
    //AUIGrid 생성 후 반환 ID
    var custInfoGridID;
    var memInfoGridID;
    var docGridID;
    var callLogGridID;
    var payGridID;
    var transGridID;
    var autoDebitGridID;
    var discountGridID;
    var afterServceGridID;
    var beforeServceGridID;
    var orderListGirdID;
    
    $(document).ready(function() {
        
        //Button Hide
        $("#_memReSelected").css("display" , "none");
        
        //Call Curier List
        doGetCombo("/sales/ccp/selectCurierListJsonList", '', '', '_inputCourierSelect', 'S', '');
        
        //Consignment Init
        fn_consignmentCheckFalse();
        
        //Draw Grid
        createAUIGrid();
        createAUIGrid2();
        createAUIGrid3();
        createAUIGrid4();
        createAUIGrid5();
        createAUIGrid6();
        createAUIGrid7();
        createAUIGrid8();
        createAUIGrid9();
        createAUIGrid10();
        createAUIGrid11();
        
        //Call Ajax (for Grid)
      /*   fn_selectOrderSameRentalGroupOrderList();
        fn_selectMembershipInfoList();
        fn_selectDocumentList();
        fn_selectCallLogList();
        fn_selectPaymentList();
        fn_selectTransList();
        fn_selectAutoDebitList();
        fn_selectDiscountList();
        fn_selectAfterServiceList();
        fn_selectBeforeServiceList(); 
        fn_selectOrderJsonList(); */ 
        
        //resize
        fn_allGridResize();
        
        //Reselect(Whole)
        $("#_reSelect").click(function() {
            self.location.href = getContextPath()+"/sales/ccp/insertCcpAgreementSearch.do";
        });
        
        //Member Search Pop
        $("#_memSearch").click(function() {
            Common.popupDiv('/sales/ccp/searchMemberPop.do' , $('#_searchForm').serializeJSON(), null , true, '_searchDiv');
            
        });
        
        //Reselect(Member)
        $("#_memReSelected").click(function() {

            fn_reSelected();
        });
        
        //confirm click(Member Confirm)
        $("#_memConfirm").click(function() {
            
            
            var inputVal = $("#_inputMemCode").val();
            fn_getMemCodeConfirm(inputVal);
            
        });
        
        
        // New Order Add 
        $("#_newOrderConfirm").click(function() {
			
			var tempInputval = $("#_inputConfirmNewOrder").val();
			fn_getOrderIdResult(tempInputval);
			
		});
        
        // Consignment Change
        $("#_consignment").change(function() {
        	
        	if($("#_consignment").is(":checked") == true){
                
        		fn_consignmentCheckTrue();
        		
            }else{
                
            	fn_consignmentCheckFalse();
            }
        	
		});
        
        $("input[name='inputCourier']").change(function() {
        	
        	fn_consignmentCheckTrue();
			
		});
        
        //Save
        $("#_saveBtn").click(function() {
			
        	//validation
        	if(fn_saveValidation() == false){
        		   
        		return;
        		
        	}else{
        		
        		//Disable Value
        		$("#_inputProgressR").val($("#_inputProgress").val());
                $("#_inputAgreementStatusR").val($("#_inputAgreementStatus").val());
                
                // Consignment Check
                if($("#_consignment").is(":checked") == true){
                	$("#_consignment").val(true);
                }else{
                	$("#_consignment").val(false);
                }
        		
        		var data ={};
        		var param = AUIGrid.getGridData(orderListGirdID);
        		data.add = param;
        		data.form = $("#_insForm").serializeJSON();
        	    
        		Common.ajax("POST", "/sales/ccp/insertAgreement.do", data, function(result){
        			
        			Common.confirm("Contract agreement successfully saved. Are you sure want to upload attachment(s) for this agreement ?", "", ""); //callback missing, confirm missing
        			if($("#_inputAgreementType").val() == '949'){
        				Common.ajax("GET", "/sales/ccp/sendSuccessEmail.do", result, function(result){
        					 console.log(result.message);
        					/* Common.alert(result.message); */
        				});
        			}
        			
        		    //disable Proc
        		    fn_disableAllField();
        			
        		});
        	}
		});
        
        //Order Search
        $("#_newOrderSearch").click(function() {
        	Common.popupDiv('/sales/ccp/searchOrderNoByEditPop.do' , $('#_searchForm').serializeJSON(), null , true, '_searchEditDiv');
		});
        
    });//Doc Ready End
   
    function fn_disableAllField(){
    	
    	 $("#_saveBtn").css("display" , "none");
         $("#_clearBtn").css("display" , "none");
         $("#_inputMemCode").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_memConfirm").css("display" , "none");
         $("#_memSearch").css("display" , "none");
         $("#_memReSelected").css("display" , "none");
         $("#_inputDocQty").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_inputAgreementType").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_inputPeriodStart").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_inputPeriodEnd").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_agreementMsg").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_agreementAgmRemark").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_consignment").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("input[name='inputCourier']").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_inputConsignmentNo").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_inputCourierSelect").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_inputAgmReq").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_consignmentReciveDt").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_inputConfirmNewOrder").attr({"disabled" : "disabled", "class" : "wp100 disabled"});
         $("#_inputConfirmNewOrder").val("");
         $("#_newOrderConfirm").css("display" , "none");
         
         AUIGrid.hideColumnByDataField(orderListGirdID, "undefined");
         
    }
    ////////////////////////////////////////////////////////////////////////////////////
    function createAUIGrid() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "salesOrdNo", headerText  : "Order No",
                width       : '10%',          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code",       headerText  : "Status",
                width       : '15%',          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code1",      headerText  : "App Type",
                width       : '15%',          editable        : false,
                style       : 'left_style'
            }, {
                dataField   : "salesDt",    headerText  : "Order Date",
                width       : '20%',          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "name",       headerText  : "Customer Name",
                width       : '20%',          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "nric",       headerText  : "NRIC/Company No",
                width       : '20%',          editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "salesOrdId", visible     : false //salesOrderId
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
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
        
        custInfoGridID = GridCommon.createAUIGrid("grid_custInfo_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid2() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "mbrshNo",        headerText  : "Membership<br>No",
                width       : '8%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshBillNo",    headerText  : "Bill No",
                width       : '8%',              editable        : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshCrtDt",     headerText  : "Date",
                width       : '8%',               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshStusCode",  headerText  : "Status",
                width       : '8%',               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "pacName",        headerText  : "Package",
                width       : '44%',     style       : 'left_style'
            }, {
                dataField   : "mbrshStartDt",   headerText  : "Start",
                width       : '8%',               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshExprDt",    headerText  : "End",
                width       : '8%',               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "mbrshDur",       headerText  : "Duration<br>(month)",
                width       : '8%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "salesOrdId", visible     : false //salesOrderId
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
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
        
        memInfoGridID = GridCommon.createAUIGrid("grid_memInfo_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid3() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "codeName",   headerText  : "Type of Document",
                                            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "docSubDt",   headerText  : "Submit Date",
                width       : 120,          editable        : false,
                style       : 'left_style'
            }, {
                dataField   : "docCopyQty", headerText  : "Quantity",
                width       : 120,           editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
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
        
        docGridID = GridCommon.createAUIGrid("grid_doc_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid4() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "rownum",             headerText  : "No",
                width       : '10%',                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "codeName",           headerText  : "Type",
                width       : '10%',                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "resnDesc",           headerText  : "Feedback",
                width       : '10%',                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "stusName",           headerText  : "Action",
                width       : '10%',                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "callRosAmt",         headerText  : "Amount",
                width       : '10%',                   editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "callRem",            headerText  : "Remark",
                width       : '20%',                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "rosCallerUserName",  headerText  : "Caller",
                width       : '10%',                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "callCrtUserName",    headerText  : "Creator",
                width       : '10%',                  editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "callCrtDt",          headerText  : "Create Date",
                width       : '10%',                  editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : false,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",            
            headerHeight        : 30,       
            rowHeight           : 150,   
            wordWrap            : true, 
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,         //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        callLogGridID = GridCommon.createAUIGrid("grid_callLog_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid5() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "orNo",           headerText  : "Receipt No",
                width       : '10%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "revReceiptNo",   headerText  : "Reverse For",
                width       : '10%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "payData",        headerText  : "Payment Date",
                width       : '10%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "codeDesc",       headerText  : "Payment Type",
                width       : '10%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "accCode",        headerText  : "Debtor Acc",
                width       : '10%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code",           headerText  : "Key-In Branch<br>(Code)",
                width       : '10%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "name1",          headerText  : "Key-In Branch<br>(Name)",
                width       : '15%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "totAmt",         headerText  : "Total Amount",
                width       : '15%',              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "userName",       headerText  : "Creator",
                width       : '10%',               editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
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
        
        payGridID = GridCommon.createAUIGrid("grid_pay_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid6() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "colType",      headerText  : "colType",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colCurMth",    headerText  : "colCurMth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev1Mth",  headerText  : "colPrev1Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev2Mth",  headerText  : "colPrev2Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev3Mth",  headerText  : "colPrev3Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev4Mth",  headerText  : "colPrev4Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "colPrev5Mth", headerText  : "colPrev5Mth",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
       var gridPros = {
            usePaging           : false,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
            showStateColumn     : true,             
            displayTreeOpen     : false,            
            selectionMode       : "singleRow",  //"multipleCells",
            showHeader          : false,
          //headerHeight        : 30,       
            useGroupingPanel    : false,        //그룹핑 패널 사용
            skipReadonlyColumns : true,         //읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            wrapSelectionMove   : true,         //칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            showRowNumColumn    : false,        //줄번호 칼럼 렌더러 출력    
            noDataMessage       : "No order found.",
            groupingMessage     : "Here groupping"
        };
        
        transGridID = GridCommon.createAUIGrid("grid_trans_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid7() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "crtDtMm",      headerText  : "Month",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "batchMode",    headerText  : "Mode",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code",         headerText  : "Bank",
                                              editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "crtDtDd",      headerText  : "Date Deduct",
                width       : 150,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "bankDtlAmt",   headerText  : "Amount",
                width       : 100,            editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "isApproveStr", headerText  : "Success ?",
                width       : 120,            editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
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
        
        autoDebitGridID = GridCommon.createAUIGrid("grid_autoDebit_wrap", columnLayout, "", gridPros);
    }
    
    function createAUIGrid8() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "salesOrdNo",      headerText  : "Order No",
                width       : 100,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "codeDesc",        headerText  : "DiscountType",
                width       : 180,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "dcAmtPerInstlmt", headerText  : "AmtPerInstalment",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "dcStartInstlmt",  headerText  : "Start Installment",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "dcEndInstlmt",    headerText  : "End Installment",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "rem",             headerText  : "Remark",
                                                 editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
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
        
        discountGridID = GridCommon.createAUIGrid("grid_discount_wrap", columnLayout, "", gridPros);
    }
    
   
  
        function createAUIGrid9() {
        
        //AUIGrid 칼럼 설정
        var columnLayout = [{
                dataField   : "asNo",      headerText  : "AS No",
                width       : 100,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "asResultNo",        headerText  : "ASR No",
                width       : 180,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "code", headerText  : "Status",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "asReqstDt",  headerText  : "Request Date",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "asSetlDt",    headerText  : "Settle Date",
                width       : 120,               editable    : false,
                style       : 'left_style'
            }, {
                dataField   : "resnDesc",             headerText  : "Error Code",
                                                 editable    : false,
                style       : 'left_style'
            },{
                dataField   : "resnDesc1",             headerText  : "Error Desc",
                editable    : false,
                style       : 'left_style'
            },{
                dataField   : "memCode",             headerText  : "CT Code",
                editable    : false,
                style       : 'left_style'
            },{
                dataField   : "resnDesc2",             headerText  : "Solution",
                editable    : false,
                style       : 'left_style'
            },{
                dataField   : "asTotAmt",             headerText  : "Amount",
                editable    : false,
                style       : 'left_style'
            }];

        //그리드 속성 설정
        var gridPros = {
            usePaging           : true,         //페이징 사용
            pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
            editable            : false,            
            fixedColumnCount    : 0,            
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
        
        afterServceGridID = GridCommon.createAUIGrid("grid_afterService_wrap", columnLayout, "", gridPros);
    }
    
        function createAUIGrid10() {
            
            //AUIGrid 칼럼 설정
            var columnLayout = [{
                    dataField   : "no",      headerText  : "BS No",
                    width       : 100,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "bsMonth",        headerText  : "BS Month",
                    width       : 180,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "code", headerText  : "Type",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "code1",  headerText  : "Status",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "no1",    headerText  : "BSR No",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "setlDt",             headerText  : "Settle Date",
                                                     editable    : false,
                    style       : 'left_style'
                },{
                    dataField   : "memCode",             headerText  : "Cody Code",
                    editable    : false,
                    style       : 'left_style'
                 },{
                     dataField   : "code3",             headerText  : "Fail Reason",
                     editable    : false,
                     style       : 'left_style'
                  },{
                      dataField   : "code2",             headerText  : "Collection Reason",
                      editable    : false,
                      style       : 'left_style'
                   }];

            //그리드 속성 설정
            var gridPros = {
                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 0,            
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
            
            beforeServceGridID = GridCommon.createAUIGrid("grid_beforeService_wrap", columnLayout, "", gridPros);
        }
        
function createAUIGrid11() {
            
            //AUIGrid 칼럼 설정
            var columnLayout = [{
                    dataField   : "salesOrdNo",      headerText  : "Order No",
                    width       : 100,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "salesDt",        headerText  : "Order Date",
                    width       : 180,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "codeName", headerText  : "App Type",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "stkDesc",  headerText  : "Product",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "name",    headerText  : "Status",
                    width       : 120,               editable    : false,
                    style       : 'left_style'
                }, {
                    dataField   : "name1",             headerText  : "Customer Name",
                                                     editable    : false,
                    style       : 'left_style'
                },{
                    dataField   : "salesOrdId",   visible : false
                 },{
                     dataField   : "nric",             headerText  : "NRIC/Company No",
                     editable    : false,
                     style       : 'left_style'
                  },{
                     dataField : "undefined", 
                     headerText : " ", 
                     width : '10%',
                     renderer : {
                              type : "ButtonRenderer", 
                              labelText : "Remove", 
                              onclick : function(rowIndex, columnIndex, value, item) {
                                fn_removeRow(item.salesOrdId);
                            }
                     }
            }];

            //그리드 속성 설정
            var gridPros = {
                usePaging           : true,         //페이징 사용
                pageRowCount        : 10,           //한 화면에 출력되는 행 개수 20(기본값:20)            
                editable            : false,            
                fixedColumnCount    : 0,            
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
            
            orderListGirdID = GridCommon.createAUIGrid("grid_orderList_wrap", columnLayout, "", gridPros);
        }
    // 리스트 조회.
    function fn_selectOrderSameRentalGroupOrderList() {        
        Common.ajax("GET", "/sales/order/selectSameRentalGrpOrderJsonList.do", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(custInfoGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectMembershipInfoList() {        
        Common.ajax("GET", "/sales/order/selectMembershipInfoJsonList.do", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(memInfoGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectDocumentList() {        
        Common.ajax("GET", "/sales/order/selectDocumentJsonList.do", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(docGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectCallLogList() {        
        Common.ajax("GET", "/sales/order/selectCallLogJsonList.do", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(callLogGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectPaymentList() {        
        Common.ajax("GET", "/sales/order/selectPaymentJsonList.do", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(payGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectTransList() {        
        Common.ajax("GET", "/sales/order/selectLast6MonthTransJsonList.do", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(transGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectAutoDebitList() {        
        Common.ajax("GET", "/sales/order/selectAutoDebitJsonList.do", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(autoDebitGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectDiscountList() {        
        Common.ajax("GET", "/sales/order/selectDiscountJsonList.do", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(discountGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectAfterServiceList(){
        Common.ajax("GET", "/sales/ccp/selectAfterServiceJsonList", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(afterServceGridID, result);
        });
    }
    
    // 리스트 조회.
    function fn_selectBeforeServiceList(){
        Common.ajax("GET", "/sales/ccp/selectBeforeServiceJsonList", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(beforeServceGridID, result);
        });
    }
    
    //리스트 조회
    function fn_selectOrderJsonList(){
        Common.ajax("GET", "/sales/ccp/selectOrderJsonList", $("#_searchForm").serialize(), function(result) {
            AUIGrid.setGridData(orderListGirdID, result);
        });
    }
    
    function chgTab(tabNm) {
        switch(tabNm) {
            case 'custInfo' :
                AUIGrid.resize(custInfoGridID, 1550, 380);
                break;
            case 'memInfo' :
                AUIGrid.resize(memInfoGridID, 1550, 380);
                break;
            case 'docInfo' :
                AUIGrid.resize(docGridID, 1550, 380);
                break;
            case 'callLogInfo' :
                AUIGrid.resize(callLogGridID, 1550, 380);
                break;
            case 'payInfo' :
                AUIGrid.resize(payGridID, 1550, 380);
                break;
            case 'transInfo' :
                AUIGrid.resize(transGridID, 1550, 380);
                break;
            case 'autoDebitInfo' :
                AUIGrid.resize(autoDebitGridID, 1550, 380);
                break;
            case 'discountInfo' :
                AUIGrid.resize(discountGridID, 1550, 380);
                break;
            case 'afterList' :
                AUIGrid.resize(afterServceGridID, 1600, 380);
                break;
            case 'beforeList' :
                AUIGrid.resize(beforeServceGridID, 1600, 380);
                break;
        };
    }
    
    function fn_allGridResize(){
        AUIGrid.resize(custInfoGridID, 1550, 380);
        AUIGrid.resize(memInfoGridID, 1550, 380);
        AUIGrid.resize(docGridID, 1550, 380);
        AUIGrid.resize(callLogGridID, 1550, 380);
        AUIGrid.resize(payGridID, 1550, 380);
        AUIGrid.resize(transGridID, 1550, 380);
        AUIGrid.resize(autoDebitGridID, 1550, 380);
        AUIGrid.resize(discountGridID, 1550, 380);
        AUIGrid.resize(afterServceGridID, 1600, 380);
        AUIGrid.resize(beforeServceGridID, 1600, 380);
    }
    
    
    function fn_getMemCodeConfirm(inputVal){
        
        $.ajax({
            
            type : "GET",
            url : getContextPath() + "/sales/ccp/getMemCodeConfirm",
            contentType: "application/json;charset=UTF-8",
            crossDomain: true,
            data: {inputMemCode : inputVal},
            dataType: "json",
            success : function (data) {
                
                $("#_inputMemCode").val(data.memCode);
                $("#_hiddenInputMemCode").val(data.memCode);
                $("#_govAgMemId").val(data.memId);
                fn_selected();
            },
            error : function (data) {
                if(data == null){               //error
                    Common.alert("fail to Load DB");
                }else{                            // No data
                    Common.alert("Unable to find ["+inputVal+"] in system. Please ensure you key in the correct member code.");
                }
                
                
            }
        });
    }
    ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    function fn_selected(){
        
          $("#_inputMemCode").attr({"readonly" : "readonly" , "class" : "w100 readonly"});
          $("#_memReSelected").css("display" , "");
          $("#_memConfirm").css("display" , "none");
          $("#_memSearch").css("display" , "none");
          $("#_closeMemPop").click();
        
    }
    
    function fn_reSelected(){
        $("#_inputMemCode").val('');
        $("#_hiddenInputMemCode").val('');
        $("#_inputMemCode").attr({"readonly" : false , "class" : ""});
        $("#_memReSelected").css("display" , "none");
        $("#_memConfirm").css("display" , "");
        $("#_memSearch").css("display" , "");
        
    }
    
    
    function fn_getOrderIdResult(ordNum){
        
        $.ajax({
            
            type : "GET",
            url : getContextPath() + "/sales/ccp/getOrderId",
            contentType: "application/json;charset=UTF-8",
            crossDomain: true,
            data: {salesOrderNo : ordNum},
            dataType: "json",
            success : function (data) {
                
                var ordId = data.ordId;
                $("#_addOrdId").val(ordId);
                Common.ajax("GET", "/sales/ccp/selectOrderAddJsonList", $("#_newOrderAddForm").serialize(), function(result){
                	AUIGrid.addRow(orderListGirdID, result, "last");
                });
            },
            error : function (data) {
                if(data == null){               //error
                    Common.alert("fail to Load DB");
                }else{                            // No data
                    Common.alert("No order found or this order.");
                }
                
                
            }
        });
    }
    
    
    //Consignment Check true
    function fn_consignmentCheckTrue(){
        
    	 //Filed Init
        fn_clearConsignmentField();
    	
    	if($("input[name='inputCourier']:checked").val() == 'C'){
    		 
    		$("input[name='inputCourier']").attr("disabled", false);
    		$("#_inputAgmReq").attr({"disabled" : false , "class" : "w100p"});
            $("#_consignmentReciveDt").attr("disabled", false);
            $("#_inputConsignmentNo").attr("disabled", false);
            $("#_inputCourierSelect").attr({"disabled" : false , "class" : "w100p"});  
    	        
    	}else{
    		
    		$("input[name='inputCourier']").attr("disabled", false);
            $("#_inputAgmReq").attr({"disabled" : false , "class" : "w100p"});
            $("#_consignmentReciveDt").attr("disabled", false);    		
    		$("#_inputConsignmentNo").attr("disabled", "disabled");
    		$("#_inputCourierSelect").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
    	}
       
    }
    
  //Consignment Check false
    function fn_consignmentCheckFalse(){
        
    	 //Filed Init
        fn_clearConsignmentField();
	  
        $("input[name='inputCourier']").attr("disabled", "disabled");
        $("input[name='inputCourier']").removeAttr("checked");
        $("#_inputConsignmentNo").attr("disabled", "disabled");
        $("#_inputCourierSelect").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_inputAgmReq").attr({"disabled" : "disabled" , "class" : "w100p disabled"});
        $("#_consignmentReciveDt").attr("disabled", "disabled");
    }
  
    //Filed Init
    function fn_clearConsignmentField(){
    	
    	$("#_inputConsignmentNo").val('');
    	$("#_inputCourierSelect").val('');
    	$("#_inputAgmReq").val('');
    	$("#_consignmentReciveDt").val('');
    }  
  
    //Save Validation
    function fn_saveValidation(){
    	
    	//멤버코드 널체크
    	if('' == $("#_inputMemCode").val() || null == $("#_inputMemCode").val()){
    		Common.alert("* Please select the Member Code.");
            return false;
    	}
    	
    	if('' == $("#_hiddenInputMemCode").val() || null == $("#_hiddenInputMemCode").val()){
    		Common.alert("* Please enter Confirm or Search.");
            return false;
    	}
    	
    	//문서 양 숫자 체크
    	if($("#_inputDocQty").val() <= -1){
    		Common.alert("* Please select the Document Quantity.");
            return false;
    	}
    	
    	//Agreement Type 널체크 (뉴/ 리뉴얼)
    	if($("#_inputAgreementType").val() <= -1){
    		Common.alert("* Please select the Agreement Type.");
            return false;
    	}
    	
    	//시작 날짜 널
    	if('' == $("#_inputPeriodStart").val() || null == $("#_inputPeriodStart").val()){
    		Common.alert("* Please select the Agreement Start Date.");
            return false;
    	}
    	
    	 //종료 날짜 null 체크
        if('' == $("#_inputPeriodEnd").val() || null == $("#_inputPeriodEnd").val()){
            Common.alert("* Please select the Agreement End Date.");
            return false;
        }
    	
    	//시작 날짜 종료날짜 비교
        if($("#_inputPeriodStart").val() > $("#_inputPeriodEnd").val()){
        	Common.alert("* Please Check Agreement Start Date cannot bigger than End Date.");
            return false;
        }
        
    	//메시지 널체크
    	if('' == $("#_agreementMsg").val() || null == $("#_agreementMsg").val()){
    		Common.alert("* Please Key-In the Message.");
    		return false;
    	}
        
    	//리마크 널체크
    	if('' == $("#_agreementAgmRemark").val() || null == $("#_agreementAgmRemark").val()){
    		Common.alert("* Please Key-In the Remark.");
    		return false;
    	}
    	
    	// 수령방법 널체크
    	if($("#_consignment").is(":checked") == true){ // 수령방법 체크시  
    		
    		//Radio Check 
    		if( '' == $("input[name='inputCourier']:checked").val() || null == $("input[name='inputCourier']:checked").val()){
                Common.alert("* Please select the Courier Method.");
                return false;
            }
    	    
    		//택배 경우 
            if($("input[name='inputCourier']:checked").val() == 'C'){
                //운송장 번호 널체크 
                if('' == $("#_inputConsignmentNo").val() || null == $("#_inputConsignmentNo").val()){
                    Common.alert("* Please key in the Courier Consignment No.");
                    return false;
                }
                 
                //운송회사 널체크 // 
                if('' == $("#_inputCourierSelect").val() || null == $("#_inputCourierSelect").val()){
                    Common.alert("* Please select the Courier.");
                    return false;   
                }
            }
    		
            //AGM Request 널체크  
            if( '' == $("#_inputAgmReq ").val() || null == $("#_inputAgmReq").val()){ 
                Common.alert("* Please select the AGM Requestor.");
                return false;
            }
            
            //Recive Date 널체크
            if('' == $("#_consignmentReciveDt").val() || null == $("#_consignmentReciveDt").val()){
                Common.alert("* Please key in the Consignment Receive Date.");
                return false;
            }
    	}
    	return true;
    }
    
    function  fn_removeRow(ordId){
    	var originalOrdId = $("#salesOrderId").val();
    	if(originalOrdId == ordId){
    		Common.alert("Item disallowed remove from list.");
    	}else{
    		 AUIGrid.removeRow(orderListGirdID, "selectedIndex");  
    		 AUIGrid.removeSoftRows(orderListGirdID);
    		 Common.alert("Item has been removed from list.");
    	}
    	
    }
</script>
<section id="content"> <!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>Order list</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>New Government Agreement</h2>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="_newOrderAddForm">
    <input id="_addOrdId" name="addOrdId" type="hidden" >
</form>

<form action="#" method="get" id="_searchForm">
<input id="salesOrderId" name="salesOrderId" type="hidden" value="${orderDetail.basicInfo.ordId}">  
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:180px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr id="_resultTr" >
    <th scope="row">Order No</th>
    <td><input type="text" title="" placeholder="" class=""  value="${salesOrderNo}" readonly="readonly"/><p class="btn_sky"><a href="#" id="_reSelect">Reselect</a></p></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result" id="_searchResultSection" ><!-- search_result start -->

<section class="tap_wrap"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li><a href="#" class="on">Order Info</a></li>
    <li><a href="#" onclick="javascript:chgTab('afterList');">After Service</a></li>
    <li><a href="#" onclick="javascript:chgTab('beforeList');">Before Service</a></li>
</ul>

<article class="tap_area"><!-- tap_area start -->

<section class="tap_wrap mt0"><!-- tap_wrap start -->
    <ul class="tap_type1 num4">
        <li><a href="#" class="on">Basic Info</a></li>
        <li><a href="#">HP / Cody</a></li>
        <li><a href="#" onClick="javascript:chgTab('custInfo');">Customer Info</a></li>
        <li><a href="#">Installation Info</a></li>
        <li><a href="#">Mailing Info</a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN'}">
    <li><a href="#">Payment Channel</a></li>
</c:if>
        <li><a href="#" onClick="javascript:chgTab('memInfo');">Membership Info</a></li>
        <li><a href="#" onClick="javascript:chgTab('docInfo');">Document Submission</a></li>
        <li><a href="#" onClick="javascript:chgTab('callLogInfo');">Call Log</a></li>
<c:if test="${orderDetail.basicInfo.appTypeCode == 'REN' && orderDetail.basicInfo.rentChkId == '122'}">
    <li><a href="#">Guarantee Info</a></li>
</c:if>
       <li><a href="#" onClick="javascript:chgTab('payInfo');">Payment Listing</a></li>
       <li><a href="#" onClick="javascript:chgTab('transInfo');">Last 6 Months Transaction</a></li>
       <li><a href="#">Order Configuration</a></li>
       <li><a href="#" onClick="javascript:chgTab('autoDebitInfo');">Auto Debit Result</a></li>
       <li><a href="#">Relief Certificate</a></li>
       <li><a href="#" onClick="javascript:chgTab('discountInfo');">Discount</a></li>
    </ul>

    <article class="tap_area"><!-- tap_area start -->

    <ul class="right_btns mb10">
        <li><p class="btn_blue2"><a href="#">View Ledger (1)</a></p></li>
        <li><p class="btn_blue2"><a href="#">View Ledger (2)</a></p></li>
    </ul>
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
 <tr>
    <th scope="row">Progress Status</th>
    <td><span>${orderDetail.logView.prgrs}</span></td>
    <th scope="row">Agreement No</th>
    <td><span>${orderDetail.agreementView.govAgItmBatchNo}</span></td>
    <th scope="row">Agreement Expiry</th>
    <td><span>${orderDetail.agreementView.govAgEndDt}</span></td>
</tr>
<tr>
    <th scope="row">Order No</th>
    <td>${orderDetail.basicInfo.ordNo}</td>
    <th scope="row">Order Date</th>
    <td>${orderDetail.basicInfo.ordDt}</td>
    <th scope="row">Status</th>
    <td>${orderDetail.basicInfo.ordStusName}</td>
</tr>
<tr>
    <th scope="row">Application Type</th>
    <td>${orderDetail.basicInfo.appTypeName}</td>
    <th scope="row">Reference No</th>
    <td>${orderDetail.basicInfo.refNo}</td>
    <th scope="row">Key At(By)</th>
    <td>${orderDetail.basicInfo.ordCrtUserId}</td>
</tr>
<tr>
    <th scope="row">Product</th>
    <td>${orderDetail.basicInfo.stockDesc}</td>
    <th scope="row">PO Number</th>
    <td>${orderDetail.basicInfo.ordPoNo}</td>
    <th scope="row">Key-inBranch</th>
    <td>(${orderDetail.basicInfo.keyinBrnchCode} )${orderDetail.basicInfo.keyinBrnchName}</td>
</tr>
<tr>
    <th scope="row">PV</th>
    <td>${orderDetail.basicInfo.ordPv}</td>
    <th scope="row">Price/RPF</th>
    <td>${orderDetail.basicInfo.ordAmt}</td>
    <th scope="row">Rental Fees</th>
    <td>${orderDetail.basicInfo.mthRentalFees}</td>
</tr>
<tr>
    <th scope="row">Installment Duration</th>
    <td>${orderDetail.basicInfo.installmentDuration}</td>
    <th scope="row">PV Month(Month/Year)</th>
    <td>${orderDetail.basicInfo.ordPvMonth}/${orderDetail.basicInfo.ordPvYear}</td>
    <th scope="row">Rental Status</th>
    <td>${orderDetail.basicInfo.rentalStatus}</td>
</tr>
<tr>
    <th scope="row">Promotion</th>
    <td colspan="3"><c:if test="${orderDetail.basicInfo.ordPromoId > 0}">(${orderDetail.basicInfo.ordPromoCode}) ${orderDetail.basicInfo.ordPromoDesc}</c:if></td>
    <th scope="row">Related No</th>
    <td>${orderDetail.basicInfo.ordPromoRelatedNo}</td>
</tr>
<tr>
    <th scope="row">Serial Number</th>
    <td>${orderDetail.installationInfo.lastInstallSerialNo}</td>
    <th scope="row">Sirim Number</th>
    <td>${orderDetail.installationInfo.lastInstallSirimNo}</td>
    <th scope="row">Update At(By)</th>
    <td>${orderDetail.basicInfo.updDt}( ${orderDetail.basicInfo.updUserId})</td>
</tr>
<tr>
    <th scope="row">Obligation Period</th>
    <td colspan="5">${orderDetail.basicInfo.obligtYear}</td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5">${orderDetail.basicInfo.ordRem}</td>
</tr>
<tr>
    <th scope="row">CCP Feedback Code</th>
    <td colspan="5">${orderDetail.ccpFeedbackCode.code}-${orderDetail.ccpFeedbackCode.resnDesc}</td>
</tr>
<tr>
    <th scope="row">CCP Remark</th>
    <td colspan="5">${orderDetail.ccpInfo.ccpRem}</td>
</tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <div class="divine_auto"><!-- divine_auto start -->

    <div style="width:50%;">

    <div class="border_box"><!-- border_box start -->

    <aside class="title_line"><!-- title_line start -->
    <h3 class="pt0">Salesman Info</h3>
    </aside><!-- title_line end -->
    
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
<tr>
    <th rowspan="3" scope="row">Order Made By</th>
    <td><span class="txt_box">${orderDetail.salesmanInfo.orgCode} (Organization Code)<i>(${orderDetail.salesmanInfo.memCode1}) ${orderDetail.salesmanInfo.name1} - ${orderDetail.salesmanInfo.telMobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.salesmanInfo.grpCode} (Group Code)<i>(${orderDetail.salesmanInfo.memCode2}) ${orderDetail.salesmanInfo.name2} - ${orderDetail.salesmanInfo.telMobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.salesmanInfo.deptCode} (Department Code)<i>(${orderDetail.salesmanInfo.memCode3}) ${orderDetail.salesmanInfo.name3} - ${orderDetail.salesmanInfo.telMobile3}</i></span></td>
</tr>
<tr>
    <th scope="row">Salesman Code</th>
    <td><span>${orderDetail.salesmanInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row">Salesman Name</th>
    <td><span>${orderDetail.salesmanInfo.name}</span></td>
</tr>
<tr>
    <th scope="row">Salesman NRIC</th>
    <td><span>${orderDetail.salesmanInfo.nric}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${orderDetail.salesmanInfo.telMobile}</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>${orderDetail.salesmanInfo.telOffice}</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>${orderDetail.salesmanInfo.telHuse}</span></td>
</tr>
    </tbody>
    </table><!-- table end -->

    </div><!-- border_box end -->

    </div>

    <div style="width:50%;">

    <div class="border_box"><!-- border_box start -->

    <aside class="title_line"><!-- title_line start -->
    <h3 class="pt0">Cody Info</h3>
    </aside><!-- title_line end -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
<tr>
    <th rowspan="3" scope="row">Service By</th>
    <td><span class="txt_box">${orderDetail.codyInfo.orgCode} (Organization Code)<i>(${orderDetail.codyInfo.memCode1}) ${orderDetail.codyInfo.name1} - ${orderDetail.codyInfo.telMobile1}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.codyInfo.grpCode} (Group Code)<i>(${orderDetail.codyInfo.memCode2}) ${orderDetail.codyInfo.name2} - ${orderDetail.codyInfo.telMobile2}</i></span></td>
</tr>
<tr>
    <td><span class="txt_box">${orderDetail.codyInfo.deptCode} (Department Code)<i>(${orderDetail.codyInfo.memCode3}) ${orderDetail.codyInfo.name3} - ${orderDetail.codyInfo.telMobile3}</i></span></td>
</tr>
<tr>
    <th scope="row">Cody Code</th>
    <td><span>${orderDetail.salesmanInfo.memCode}</span></td>
</tr>
<tr>
    <th scope="row">Cody Name</th>
    <td><span>${orderDetail.salesmanInfo.name}</span></td>
</tr>
<tr>
    <th scope="row">Cody NRIC</th>
    <td><span>${orderDetail.salesmanInfo.nric}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${orderDetail.salesmanInfo.telMobile}</span></td>
</tr>
<tr>
    <th scope="row">Office No</th>
    <td><span>${orderDetail.salesmanInfo.telOffice}</span></td>
</tr>
<tr>
    <th scope="row">House No</th>
    <td><span>${orderDetail.salesmanInfo.telHuse}</span></td>
</tr>
    </tbody>
    </table><!-- table end -->

    </div><!-- border_box end -->

    </div>

    </div><!-- divine_auto end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->
    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:130px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
 <tr>
    <th scope="row">Customer ID</th>
    <td><span>${orderDetail.basicInfo.custId}</span></td>
    <th scope="row">Customer Name</th>
    <td colspan="3"><span>${orderDetail.basicInfo.custName}</span></td>
</tr>
<tr>
    <th scope="row">Customer Type</th>
    <td><span>${orderDetail.basicInfo.custType}</span></td>
    <th scope="row">NRIC/Company No</th>
    <td><span>${orderDetail.basicInfo.custNric}</span></td>
    <th scope="row">JomPay Ref-1</th>
    <td><span>${orderDetail.basicInfo.jomPayRef}</span></td>
</tr>
<tr>
    <th scope="row">Nationality</th>
    <td><span>${orderDetail.basicInfo.custNation}</span></td>
    <th scope="row">Gender</th>
    <td><span>${orderDetail.basicInfo.custGender}</span></td>
    <th scope="row">Race</th>
    <td><span>${orderDetail.basicInfo.custRace}</span></td>
</tr>
<tr>
    <th scope="row">VA Number</th>
    <td><span>${orderDetail.basicInfo.custVaNo}</span></td>
    <th scope="row">Passport Exprire</th>
    <td><span>${orderDetail.basicInfo.custPassportExpr}</span></td>
    <th scope="row">Visa Exprire</th>
    <td><span>${orderDetail.basicInfo.custVisaExpr}</span></td>
</tr>
    </tbody>
    </table><!-- table end -->

    <aside class="title_line"><!-- title_line start -->
    <h3>Same Rental Group Order(s)</h3>
    </aside><!-- title_line end -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_custInfo_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
<tr>
    <th rowspan="3" scope="row">Installation Address</th>
    <td colspan="3"><span>${orderDetail.installationInfo.instAddr1}</span></td>
    <th scope="row">Country</th>
    <td><span>${orderDetail.installationInfo.instCnty}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${orderDetail.installationInfo.instAddr2}</span></td>
    <th scope="row">State</th>
    <td><span>${orderDetail.installationInfo.instState}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${orderDetail.installationInfo.instAddr3}</span></td>
    <th scope="row">Area</th>
    <td><span>${orderDetail.installationInfo.instArea}</span></td>
</tr>
<tr>
    <th scope="row">Prefer Install Date</th>
    <td><span>${orderDetail.installationInfo.preferInstDt}</span></td>
    <th scope="row">Prefer Install Time</th>
    <td><span>${orderDetail.installationInfo.preferInstTm}</span></td>
    <th scope="row">Postcode</th>
    <td><span>${orderDetail.installationInfo.instPostCode}</span></td>
</tr>
<tr>
    <th scope="row">Instruction</th>
    <td colspan="5"><span>${orderDetail.installationInfo.instct}</span></td>
</tr>
<tr>
    <th scope="row">DSC Verification Remark</th>
    <td colspan="5"><span>${orderDetail.installationInfo.vrifyRem}</span></td>
</tr>
<tr>
    <th scope="row">DSC Branch</th>
    <td colspan="3"><span>(${orderDetail.installationInfo.dscCode} )${orderDetail.installationInfo.dscName}</span></td>
    <th scope="row">Installed Date</th>
    <td><span>${orderDetail.installationInfo.firstInstallDt}</span></td>
</tr>
<tr>
    <th scope="row">CT Code</th>
    <td><span>${orderDetail.installationInfo.lastInstallCtCode}</span></td>
    <th scope="row">CT Name</th>
    <td colspan="3"><span>${orderDetail.installationInfo.lastInstallCtName}</span></td>
</tr>
   
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>${orderDetail.installationInfo.instCntName}</span></td>
    <th scope="row">Gender</th>
    <td><span>${orderDetail.installationInfo.instCntGender}</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>${orderDetail.installationInfo.instCntNric}</span></td>
    <th scope="row">Email</th>
    <td><span>${orderDetail.installationInfo.instCntEmail}</span></td>
    <th scope="row">Fax No</th>
    <td><span>${orderDetail.installationInfo.instCntTelF}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${orderDetail.installationInfo.instCntTelM}</span></td>
    <th scope="row">Office No</th>
    <td><span>${orderDetail.installationInfo.instCntTelO}</span></td>
    <th scope="row">House No</th>
    <td><span>${orderDetail.installationInfo.instCntTelR}</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>${orderDetail.installationInfo.instCntPost}</span></td>
    <th scope="row">Department</th>
    <td><span>${orderDetail.installationInfo.instCntDept}</span></td>
    <th scope="row"></th>
    <td></td>
</tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
<tr>
    <th rowspan="3" scope="row">Mailing Address</th>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailAdd1}</span></td>
    <th scope="row">Country</th>
    <td><span>${orderDetail.mailingInfo.mailCnty}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailAdd2}</span></td>
    <th scope="row">State</th>
    <td><span>${orderDetail.mailingInfo.mailState}</span></td>
</tr>
<tr>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailAdd3}</span></td>
    <th scope="row">Area</th>
    <td><span>${orderDetail.mailingInfo.mailArea}</span></td>
</tr>
    <tr>
    <th scope="row">Billing Group</th>
    <td><span>${orderDetail.mailingInfo.billGrpNo}</span></td>
        <th scope="row">Billing Type</th>
    <td>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billSms != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">SMS<i>${orderDetail.mailingInfo.mailCntTelM}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>SMS</span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billPost != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">Post<i>${orderDetail.mailingInfo.fullAddress}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>Post</span>
    </c:otherwise>
  </c:choose>
    </label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.mailingInfo.billState != 0}">
       <input type="checkbox" onClick="return false" checked/>
       <span class="txt_box">E-statement><i>${orderDetail.mailingInfo.billStateEmail}</i></span>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
       <span>E-statement</span>
    </c:otherwise>
  </c:choose>
     </label>
    </td>
        <th scope="row">Postcode</th>
    <td><span>${orderDetail.mailingInfo.mailPostCode}</span></td>
    </tr>   
<tr>
    <th scope="row">Contact Name</th>
    <td colspan="3"><span>${orderDetail.mailingInfo.mailCntName}</span></td>
    <th scope="row">Gender</th>
    <td><span>${orderDetail.mailingInfo.mailCntGender}</span></td>
</tr>
<tr>
    <th scope="row">Contact NRIC</th>
    <td><span>${orderDetail.mailingInfo.mailCntNric}</span></td>
    <th scope="row">Email</th>
    <td><span>${orderDetail.mailingInfo.mailCntEmail}</span></td>
    <th scope="row">Fax No</th>
    <td><span>${orderDetail.mailingInfo.mailCntTelF}</span></td>
</tr>
<tr>
    <th scope="row">Mobile No</th>
    <td><span>${orderDetail.mailingInfo.mailCntTelM}</span></td>
    <th scope="row">Office No</th>
    <td><span>${orderDetail.mailingInfo.mailCntTelO}</span></td>
    <th scope="row">House No</th>
    <td><span>${orderDetail.mailingInfo.mailCntTelR}</span></td>
</tr>
<tr>
    <th scope="row">Post</th>
    <td><span>${orderDetail.mailingInfo.mailCntPost}</span></td>
    <th scope="row">Departiment</th>
    <td><span>${orderDetail.mailingInfo.mailCntDept}</span></td>
    <th scope="row"></th>
    <td></td>
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
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
    <tr>
    <th scope="row">Rental Paymode</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayModeDesc}</span></td>
    <th scope="row">Direct Debit Mode</th>
    <td><span>${orderDetail.rentPaySetInf.clmDdMode}</span></td>
    <th scope="row">Auto Debit Limit</th>
    <td><span>${orderDetail.rentPaySetInf.clmLimit}</span></td>
</tr>
<tr>
    <th scope="row">Issue Bank</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayIssBank}</span></td>
    <th scope="row">Card Type</th>
    <td><span>${orderDetail.rentPaySetInf.cardType}</span></td>
    <th scope="row">Claim Bill Date</th>
    <td><span></span></td>
</tr>
<tr>
    <th scope="row">Credit Card No</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayCrcNo}</span></td>
    <th scope="row">Name On Card</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayCrOwner}</span></td>
    <th scope="row">Expiry Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayCrcExpr}</span></td>
</tr>
 <tr>
    <th scope="row">Bank Account No</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayAccNo}</span></td>
    <th scope="row">Account Name</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayAccOwner}</span></td>
    <th scope="row">Issure NRIC</th>
    <td><span>${orderDetail.rentPaySetInf.issuNric}</span></td>
</tr>
<tr>
    <th scope="row">Apply Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayApplyDt}</span></td>
    <th scope="row">Submit Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPaySubmitDt}</span></td>
    <th scope="row">Start Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayStartDt}</span></td>
</tr>
<tr>
    <th scope="row">Reject Date</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayRejctDt}</span></td>
    <th scope="row">Reject Code</th>
    <td><span>${orderDetail.rentPaySetInf.rentPayRejct}</span></td>
    <th scope="row">Payment Team</th>
    <td><span>${orderDetail.rentPaySetInf.payTrm} month(s)</span></td>
</tr>
<tr>
    <th scope="row">Pay By Third Party</th>
    <td><span>${orderDetail.rentPaySetInf.is3party}</span></td>
    <th scope="row">Third Party ID</th>
    <td><span>${orderDetail.thirdPartyInfo.customerid}</span></td>
    <th scope="row">Third Party Type</th>
    <td><span>${orderDetail.thirdPartyInfo.c7}</span></td>
</tr>
<tr>
    <th scope="row">Third Party Name</th>
    <td colspan="3"><span>${orderDetail.thirdPartyInfo.name}</span></td>
    <th scope="row">Third Party NRIC</th>
    <td><span>${orderDetail.thirdPartyInfo.nric}</span></td>
</tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_memInfo_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
   <div id="grid_doc_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_callLog_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:155px" />
        <col style="width:*" />
        <col style="width:155px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
<tr>
    <th scope="row">Guarantee Status</th>
    <td colspan="3"><span>${orderDetail.grntnfo.grntStatus}</span></td>
</tr>
<tr>
    <th scope="row">HP Code</th>
    <td><span>${orderDetail.grntnfo.grntHPCode}</span></td>
    <th scope="row">HP Name(NRIC)</th>
    <td><span>${orderDetail.grntnfo.grntHPName}</span></td>
</tr>
<tr>
    <th scope="row">HM Code</th>
    <td><span>${orderDetail.grntnfo.grntHMCode}</span></td>
    <th scope="row">HM Name(NRIC)</th>
    <td><span>${orderDetail.grntnfo.grntHMName}</span></td>
</tr>
<tr>
    <th scope="row">SM Code</th>
    <td><span>${orderDetail.grntnfo.grntSMCode}</span></td>
    <th scope="row">SM Name(NRIC)</th>
    <td><span>${orderDetail.grntnfo.grntSMName}</span></td>
</tr>
<tr>
    <th scope="row">GM Code</th>
    <td><span>${orderDetail.grntnfo.grntGMCode}</span></td>
    <th scope="row">GM Name(NRIC)</th>
    <td><span>${orderDetail.grntnfo.grntGMName}</span></td>
</tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_pay_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_trans_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
        <col style="width:140px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
<tr>
    <th scope="row">BS Availability</th>
    <td><span>${orderDetail.orderCfgInfo.configBsGen}</span></td>
    <th scope="row">BS Frequency</th>
    <td><span>${orderDetail.orderCfgInfo.srvMemFreq} month(s)</span></td>
    <th scope="row">Last BS Date</th>
    <td><span>${orderDetail.orderCfgInfo.setlDt}</span></td>
</tr>
<tr>
    <th scope="row">BS Cody Code</th>
    <td colspan="5"><span>${orderDetail.orderCfgInfo.memCode} - ${orderDetail.orderCfgInfo.name}</span></td>
</tr>
<tr>
    <th scope="row">Config Remark</th>
    <td colspan="5"><span>${orderDetail.orderCfgInfo.configBsRem}</span></td>
</tr>
<tr>
    <th scope="row">Happy Call Service</th>
    <td colspan="5">
    <label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettIns == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
    <span>Installation Type</span></label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettBs == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
    <span>BS Type</span></label>
    <label>
  <c:choose>
    <c:when test="${orderDetail.orderCfgInfo.configSettAs == 1}">
       <input type="checkbox" onClick="return false" checked/>
    </c:when>
    <c:otherwise>
       <input type="checkbox" onClick="return false"/>
    </c:otherwise>
  </c:choose>
    <span>AS Type</span></label>
    </td>
</tr>
 <tr>
    <th scope="row">Prefer BS Week</th>
    <td colspan="5">
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 0 || orderDetail.orderCfgInfo.configBsWeek > 4}">checked</c:if> disabled/><span>None</span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 1}">checked</c:if> disabled/><span>Week1</span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 2}">checked</c:if> disabled/><span>Week2</span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 3}">checked</c:if> disabled/><span>Week3</span></label>
    <label><input type="radio" name="week" <c:if test="${orderDetail.orderCfgInfo.configBsWeek == 4}">checked</c:if> disabled/><span>Week4</span></label>
    </td>
</tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_autoDebit_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
    <span class="red_text">Disclaimer : This data is subject to Coway private information property which is not meant to view by any public other than coway internal staff only.</span>

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <table class="type1"><!-- table start -->
    <caption>table</caption>
    <colgroup>
        <col style="width:180px" />
        <col style="width:*" />
        <col style="width:150px" />
        <col style="width:*" />
    </colgroup>
    <tbody>
 <tr>
    <th scope="row">Reference No</th>
    <td><span>${orderDetail.gstCertInfo.eurcRefNo}</span></td>
    <th scope="row">Certificate Date</th>
    <td><span>${orderDetail.gstCertInfo.eurcRefDt}</span></td>
</tr>
<tr>
    <th scope="row">GST Registration No</th>
    <td colspan="3"><span>${orderDetail.gstCertInfo.eurcCustRgsNo}</span></td>
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="3"><span>${orderDetail.gstCertInfo.eurcRem}</span></td>
</tr>
    </tbody>
    </table><!-- table end -->

    </article><!-- tap_area end -->

    <article class="tap_area"><!-- tap_area start -->

    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_discount_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->

    </article><!-- tap_area end -->

    </section><!-- tap_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_afterService_wrap" style="width:100%; height:380px; margin:0 auto;"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->
    <article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_beforeService_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
    </article><!-- grid_wrap end -->
</article>

</section><!-- tap_wrap end -->


<aside class="title_line"><!-- title_line start -->
<h3>Agreement Information</h3>
</aside><!-- title_line end -->
<form id="_insForm">
<input type="hidden" name="salesOrdId" id="_salesOrdId" value="${orderDetail.basicInfo.ordId}"> 
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:180px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody> 
<tr>
    <th scope="row">Member Code<span class="must">*</span></th>
    <td>
        <input type="text" title="" placeholder="" class="" style="width:100px" id="_inputMemCode" name="inputMemCode"/> 
        <input type="hidden" id="_hiddenInputMemCode" >
        <input type="hidden" id="_govAgMemId" name="govAgMemId">
        <p class="btn_sky"><a href="#" id="_memConfirm">Confirm</a></p> 
        <p class="btn_sky"><a href="#" id="_memSearch">Search</a></p>
        <p class="btn_sky"><a  id="_memReSelected">Reselect</a></p>
    </td>
    <th scope="row">Document Quantity<span class="must">*</span></th>
    <td>
    <select class="w100p" name="inputDocQty" id="_inputDocQty">
        <option value="-1">Quantity</option>
        <option value="0">0</option>
        <option value="1">1</option>
        <option value="2">2</option>
        <option value="3">3</option>
        <option value="4">4</option>
        <option value="5">5</option>
        <option value="6">6</option>
    </select>
    </td>
    <th scope="row">Agreement Type<span class="must">*</span></th>
    <td>
    <select class="w100p" name="inputAgreementType" id="_inputAgreementType">
        <option value="-1">Type</option>
        <option value="949">New</option>
        <option value="950">Renewal</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Progress<span class="must">*</span></th>
    <td>
    <input type="hidden" name="inputProgress" id="_inputProgressR">
    <select class="w100p disabled" disabled="disabled"  id="_inputProgress">
        <option value="7" selected="selected">Agreement Submission</option>
        <option value="8">Agreement Verifying</option>
        <option value="9">Agreement Stamping & Confirmation</option>
        <option value="10">Agreement Filling</option>
    </select>
    </td>
    <th scope="row">Agreement Status<span class="must">*</span></th>
    <td>
    <input type="hidden" name="inputAgreementStatus" id="_inputAgreementStatusR">
    <select class="w100p disabled" disabled="disabled"  id="_inputAgreementStatus">
        <option value="1" selected="selected">Active</option>
        <option value="4">Completed</option>
        <option value="10">Cancelled</option>
        <option value="6">Rejected</option>
    </select>
    </td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Agreement Period</th>  
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date"  name="inputPeriodStart" id="_inputPeriodStart" readonly="readonly"/></p>
    <span>To</span>
    <p><input type="text" title="Create end Date" placeholder="DD/MM/YYYY" class="j_date" name="inputPeriodEnd" id="_inputPeriodEnd" readonly="readonly"/></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row"></th>
    <td></td>
    <th scope="row"></th>
    <td></td>
</tr>
<tr>
    <th scope="row">Message<span class="must">*</span></th>
    <td colspan="5"><textarea cols="20" rows="5" name="agreementMsg" id="_agreementMsg" ></textarea></td> 
</tr>
<tr>
    <th scope="row">AGM Remark<span class="must">*</span></th>
    <td colspan="5"><textarea cols="20" rows="5" name="agreementAgmRemark" id="_agreementAgmRemark"></textarea></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>Consignment Information<label><input type="checkbox"  id="_consignment"  name="consignment"/><span></span></label></h3>
</aside><!-- title_line end --> 

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:80px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr> 
    <th scope="row">Courier Method</th>
    <td>
    <label><input type="radio" name="inputCourier" value="H"/><span>By Hand</span></label>
    <label><input type="radio" name="inputCourier"  value="C"/><span>Courier</span></label>
    </td>
    <th scope="row">Courier Consignment No.</th>
    <td><input type="text" title="" placeholder="" class="w100p"  name="inputConsignmentNo" id="_inputConsignmentNo" maxlength="20"/></td>
    <th scope="row">Courier</th>
    <td>
    <select class="w100p" name="inputCourierSelect" id="_inputCourierSelect"></select> 
    </td>
</tr>
<tr>
    <th scope="row">AGM Requester</th>
    <td>
    <select class="w100p" name="inputAgmReq" id="_inputAgmReq"> 
        <option value="">AGM Requester</option>
        <option value="1">HP</option>
        <option value="2">CODY</option>
        <option value="1234">Customer</option>
    </select>
    </td>
    <th scope="row">Consignment Receive Date</th>
    <td><input type="text" title="Create start Date" placeholder="DD/MM/YYYY" class="j_date w100p" name="consignmentReciveDt" id="_consignmentReciveDt" readonly="readonly"/></td>
    <th scope="row"></th>
    <td></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h3>New Order</h3>
</aside><!-- title_line end -->
  

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">New Order No<span class="must">*</span></th>
    <td>
        <input type="text" title="" placeholder="" class="" style="width:100px" id="_inputConfirmNewOrder" name="inputConfirmNewOrder" maxlength="20"/>
        <p class="btn_sky"><a  id="_newOrderConfirm">Confirm New Order</a></p>
        <p class="btn_sky"><a  id="_newOrderSearch">Search</a></p>  
    </td>
</tr>
</tbody>
</table>

<article class="grid_wrap"><!-- grid_wrap start --> 
<div id="grid_orderList_wrap" style="width:100%; height:380px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a href="#" id="_saveBtn">Save</a></p></li>
    <li><p class="btn_blue2 big"><a href="#" id="_clearBtn">Clear</a></p></li>
</ul>
</form>
</section><!-- search_result end -->

</section><!-- content end -->

<aside class="bottom_msg_box"><!-- bottom_msg_box start -->
<p>Information Message Area</p>
</aside><!-- bottom_msg_box end -->
