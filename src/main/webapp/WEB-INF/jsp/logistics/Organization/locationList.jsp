<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}


#editWindow {
    font-size:13px;
}
#editWindow label, input { display:inline; }
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; }
</style>
<!-- <link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css"> -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var detailGrid;

    // 등록창
    var insDialog;
    // 수정창
    var dialog;
    var locchkcnt; 
    
    var pagestate="";

	var optionState = {chooseMessage: " 1.States "};
	var optionCity = {chooseMessage: "2. City"};
	var optionPostCode = {chooseMessage: "3. Post Code"};
	var optionArea = {chooseMessage: "4. Area"};

    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "8","codeName": "Inactive"}];
    var stockgradecomboData = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
    var instockgradecomboData = [{"codeId": "A","codeName": "A"}];
    
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"locid"       ,headerText:"WHID"           ,width:"8%"  ,height:30 , visible:true},
                        {dataField:"loccd"       ,headerText:"Code"           ,width:"12%" ,height:30 , visible:true},
                        {dataField:"locdesc"     ,headerText:"Description"    ,width:"40%" ,height:30 , visible:true},
                        {dataField:"locdtl"      ,headerText:"locaddr1"       ,width:120   ,height:30 , visible:false},
                        {dataField:"areaid"      ,headerText:"locarea"        ,width:120   ,height:30 , visible:false},
                        {dataField:"street"      ,headerText:"street"         ,width:120   ,height:30 , visible:false},
                        {dataField:"loctel1"     ,headerText:"loctel1"        ,width:90    ,height:30 , visible:false},
                        {dataField:"loctel2"     ,headerText:"loctel2"        ,width:120   ,height:30 , visible:false},
                        {dataField:"locbranch1"  ,headerText:"loc_branch"     ,width:100   ,height:30 , visible:false},
                        {dataField:"locbranch2"  ,headerText:"loc_branch"     ,width:100   ,height:30 , visible:false},
                        {dataField:"locbranch3"  ,headerText:"loc_branch"     ,width:100   ,height:30 , visible:false},
                        {dataField:"whlocgb"     ,headerText:"Location Type"  ,width:100   ,height:30 , visible:false},
                        {dataField:"whlocgbnm"   ,headerText:"Location Type"  ,width:"15%" ,height:30 , visible:true},
                        {dataField:"serialftchk" ,headerText:"Serial Check"   ,width:100   ,height:30 , visible:false},
                        {dataField:"serialptchk" ,headerText:"Serial Check"   ,width:100   ,height:30 , visible:false},
                        {dataField:"serialpdchk" ,headerText:"Serial Check"   ,width:100   ,height:30 , visible:false},
                        {dataField:"loctype"     ,headerText:"loctype"        ,width:100   ,height:30 , visible:false},
                        {dataField:"locuserid"   ,headerText:"locuserid"      ,width:100   ,height:30 , visible:false},
                        {dataField:"locupddt"    ,headerText:"locupddt"       ,width:100   ,height:30 , visible:false},
                        {dataField:"code2"       ,headerText:"code2"          ,width:100   ,height:30 , visible:false},
                        {dataField:"desc2"       ,headerText:"desc2"          ,width:100   ,height:30 , visible:false},
                        {dataField:"areanm"      ,headerText:"areanm"         ,width:100   ,height:30 , visible:false},
                        {dataField:"postcd"      ,headerText:"postcd"         ,width:100   ,height:30 , visible:false},
                        {dataField:"code"        ,headerText:"code"           ,width:100   ,height:30 , visible:false},
                        {dataField:"name"        ,headerText:"name"           ,width:100   ,height:30 , visible:false},
                        {dataField:"countrynm"   ,headerText:"countrynm"      ,width:100   ,height:30 , visible:false},
                        {dataField:"branchcd"    ,headerText:"branchcd"       ,width:100   ,height:30 , visible:false},
                        {dataField:"branchnm"    ,headerText:"Branch"         ,width:"15%" ,height:30 , visible:true},
                        {dataField:"dcode"       ,headerText:"dcode"          ,width:100   ,height:30 , visible:false},
                        {dataField:"descr"       ,headerText:"descr"          ,width:100   ,height:30 , visible:false},
                        {dataField:"codenm"      ,headerText:"Type"           ,width:"15%" ,height:30 , visible:false},
                        {dataField:"statnm"      ,headerText:"Status"         ,width:"10%" ,height:30 , visible:true},
                        {dataField:"locgrad"     ,headerText:"Location Grade" ,width:100   ,height:30 , visible:true},
                        {dataField:"locstus"     ,headerText:"locstus"        ,width:100   ,height:30 , visible:false},
                        {dataField:"user_name"   ,headerText:"nser_name"      ,width:100   ,height:30 , visible:false},
                        {dataField:"cdccode"     ,headerText:"CDC_CODE"       ,width:100   ,height:30 , visible:false},
                        {dataField:"rdccode"     ,headerText:"RDC_CODE"       ,width:100   ,height:30 , visible:false},
                        {dataField:"plant"       ,headerText:"PLANT"          ,width:100   ,height:30 , visible:false},
                        {dataField:"slplant"     ,headerText:"S/L"          ,width:100   ,height:30 , visible:false}
                       ];
    
    var detailLayout = [{dataField:"stkid"      ,headerText:"stkid"          ,width:"12%" ,height:30 , visible:false},
                        {dataField:"stkcd"      ,headerText:"CODE"           ,width:"15%" ,height:30 , visible:true},
                        {dataField:"stkdesc"    ,headerText:"Description"    ,width:"40%" ,height:30 , visible:true},
                        {dataField:"qty"        ,headerText:"Balance"        ,width:"15%" ,height:30 , visible:true},
                        {dataField:"statname"   ,headerText:"Status"         ,width:"15%" ,height:30 , visible:true},
                        {dataField:"unclamed"   ,headerText:"unClamed"       ,width:"15%" ,height:30 , visible:true},
                        {dataField:"typename"   ,headerText:"typename"       ,width:120 ,height:30 , visible:false},
                        {dataField:"catename"   ,headerText:"catename"       ,width:120 ,height:30 , visible:false},
                        {dataField:"stkcateid"  ,headerText:"stkcateid"      ,width:120 ,height:30 , visible:false},
                        {dataField:"typeid"     ,headerText:"typeid"         ,width:120 ,height:30 , visible:false},
                        {dataField:"statuscd"   ,headerText:"statuscd"       ,width:90  ,height:30 , visible:false}
                       ];
    
 /* 그리드 속성 설정
  usePaging : true, pageRowCount : 30,  fixedColumnCount : 1,// 페이지 설정
  editable : false,// 편집 가능 여부 (기본값 : false) 
  enterKeyColumnBase : true,// 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
  selectionMode : "multipleCells",// 셀 선택모드 (기본값: singleCell)                
  useContextMenu : true,// 컨텍스트 메뉴 사용 여부 (기본값 : false)                
  enableFilter : true,// 필터 사용 여부 (기본값 : false)            
  useGroupingPanel : true,// 그룹핑 패널 사용
  showStateColumn : true,// 상태 칼럼 사용
  displayTreeOpen : true,// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
  noDataMessage : "출력할 데이터가 없습니다.",
  groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
  rowIdField : "stkid",
  enableSorting : true,
  showRowCheckColumn : true,
  */
    var gridoptions = {showStateColumn : false , editable : false, usePaging : false, showFooter : false, useGroupingPanel : false };
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        
		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        //detailGrid  = GridCommon.createAUIGrid("stockBalanceGrid", detailLayout,"", gridoptions);
		
		//$("#detailView").hide();
		
		doDefCombo(comboData, '' ,'status', 'S', '');
		doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
		
		doDefCombo(stockgradecomboData, '' ,'locgrad', 'S', '');
		
		doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'loctype', 'M','f_multiCombo');
		
		AUIGrid.bind(myGridID, "cellClick", function( event ) 
	    {
			
	        
	    });
				
		
		// 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
	    {
	    	pagestate = "m";
            
            if (event.rowIndex > -1){
                fn_modyWare(event.rowIndex);
            }else{
                Common.alert('Choice Data please..');
            }
        });
		
	    AUIGrid.bind(myGridID, "updateRow", function(event) {
	    	$( "#editWindow" ).hide();
	    	$('#modForm')[0].reset();
	        
	    	pagestate = "";
	        
	        Common.ajax("POST", "/logistics/organization/locationUpdate.do", GridCommon.getEditData(myGridID), function(result) {
	        	Common.alert(result.message);
	            AUIGrid.resetUpdatedItems(myGridID, "all");
	            $("#search").click();
	        },  function(jqXHR, textStatus, errorThrown) {
	            try {
	            } catch (e) {
	            }

	            Common.alert("Fail : " + jqXHR.responseJSON.message);
	        });
	        
	       // $("#search").click();
	    });
		
 		/* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
        /* 팝업 드래그 end */

    });

    $(function(){
    	$("#loccd").keypress(function(event){
    		if (event.which == '13') {
                $("#sUrl").val("/logistics/organization/locationCdSearch.do");
                Common.searchpopupWin("searchForm", "/common/searchPopList.do","location");
            }
    	});
        $("#search").click(function(){
        	getLocationListAjax();
        	
        });
        $("#clear").click(function(){
        	doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
        	doDefCombo(comboData, '' ,'status', 'S', '');
        	doDefCombo(stockgradecomboData, '' ,'locgrad', 'S', '');
        	doGetComboData('/common/selectCodeList.do', { groupCode : 339 , orderValue : 'CODE'}, '', 'loctype', 'M','f_multiCombo');
        	$("#loccd").val('');
        	$("#locdesc").val('');
        });
        $("#update").click(function(){
        	
        	pagestate = "m";
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            console.log(selectedItem);
            if (selectedItem[0] > -1){
                fn_modyWare(selectedItem[0]);
            }else{
            Common.alert('Choice Data please..');
            }
            //AUIGrid.setSelectionByIndex(myGridID, selcell , 3);
        });
        $(".numberAmt").keyup(function(e) {
            regex = /[^.0-9]/gi;
            v = $(this).val();
            if (regex.test(v)) {
                var nn = v.replace(regex, '');
                $(this).val(v.replace(regex, ''));
                $(this).focus();
                return;
            }
         });
        
    
         $("#insert").click(function(){
        	 pagestate = "i";
        	 fn_insertWare();
        	 
        	$("#registWindow").show();
	     });    
         
         $("#download").click(function() {
        	 GridCommon.exportTo("grid_wrap", 'xlsx', "Location List");
         });
        
        $("#delete").click(function(){
            
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
            //	Common.confirm("<spring:message code='sys.common.alert.delete'/>",fn_deleteAjax(selectedItem[0]));    
            	fn_deleteWare(selectedItem[0]);
            }else{
            Common.alert('Choice Data please..');
            }
          
        });
        $("#icdccode").change(function(){
        	rdccodeFunc();
        });
               
    });
    
    function fn_modyWare(rowid){
    	
    	$("#mstatus").text(AUIGrid.getCellValue(myGridID ,rowid,'statnm'));
    	$("#mwarecd").val(AUIGrid.getCellValue(myGridID ,rowid,'loccd'));
    	$("#mwarenm").val(AUIGrid.getCellValue(myGridID ,rowid,'locdesc'));
    	$("#maddr1").val(AUIGrid.getCellValue(myGridID ,rowid,'locdtl'));
    	$("#mcontact1").val(AUIGrid.getCellValue(myGridID ,rowid,'loctel1'));
    	$("#mcontact2").val(AUIGrid.getCellValue(myGridID ,rowid,'loctel2'));
    	$("#streetDtl").val(AUIGrid.getCellValue(myGridID ,rowid,'street'));
    	$("#mareaId").val(AUIGrid.getCellValue(myGridID ,rowid,'areaid'));
    	$("#plant").val(AUIGrid.getCellValue(myGridID ,rowid,'plant'));
    	$("#slplant").val(AUIGrid.getCellValue(myGridID ,rowid,'slplant'));
    	
    	doDefCombo(stockgradecomboData, AUIGrid.getCellValue(myGridID ,rowid,'locgrad') ,'mstockgrade', 'S', '');
    	
    	var paramdata = { groupCode : '339' , orderValue : 'CODE'};
        doGetComboData('/common/selectCodeList.do', paramdata, AUIGrid.getCellValue(myGridID ,rowid,'whlocgb'),'locationtype', 'S' , '');
        
    	CommonCombo.make('mState',  "/sales/customer/selectMagicAddressComboList", '' , AUIGrid.getCellValue(myGridID ,rowid,'state'), optionState);
    	
    	var Json = {state : AUIGrid.getCellValue(myGridID ,rowid,'state')}; //Condition
    	CommonCombo.make('mCity',   "/sales/customer/selectMagicAddressComboList", Json, AUIGrid.getCellValue(myGridID ,rowid,'locdt2') , optionCity);
    	
        Json = {state : AUIGrid.getCellValue(myGridID ,rowid,'state') , city : AUIGrid.getCellValue(myGridID ,rowid,'locdt2') ,  postcode : AUIGrid.getCellValue(myGridID ,rowid,'postcd')}; //Condition
        CommonCombo.make('mArea',   "/sales/customer/selectMagicAddressComboList", Json, AUIGrid.getCellValue(myGridID ,rowid,'areanm') , optionArea);
        
        Json = {state : AUIGrid.getCellValue(myGridID ,rowid,'state') , city : AUIGrid.getCellValue(myGridID ,rowid,'locdt2') , }; //Condition
        CommonCombo.make('mPostCd', "/sales/customer/selectMagicAddressComboList", Json, AUIGrid.getCellValue(myGridID ,rowid,'postcd') , optionPostCode);

    	doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , AUIGrid.getCellValue(myGridID ,rowid,'locbranch1'),'mwarebranch1', 'S' , ''); 
    	doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , AUIGrid.getCellValue(myGridID ,rowid,'locbranch2'),'mwarebranch2', 'S' , '');
    	doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , AUIGrid.getCellValue(myGridID ,rowid,'locbranch3'),'mwarebranch3', 'S' , '');
    	
    	if (AUIGrid.getCellValue(myGridID ,rowid,'serialpdchk') == "Y"){
    		$("#pdchk").prop("checked" , true);
    	}else{
    		$("#pdchk").prop("checked" , false);
    	}
    	if (AUIGrid.getCellValue(myGridID ,rowid,'serialftchk') == "Y"){
            $("#ftchk").prop("checked" , true);
        }else{
        	$("#ftchk").prop("checked" , false);
        }
    	if (AUIGrid.getCellValue(myGridID ,rowid,'serialptchk') == "Y"){
            $("#ptchk").prop("checked" , true);
        }else{
        	$("#ptchk").prop("checked" , false);
        }
    	
    	doGetComboData('/common/selectStockLocationList.do', { locgb : '01'}, AUIGrid.getCellValue(myGridID ,rowid,'cdccode'),'mcdccode', 'S' , '');
    	doGetComboData('/common/selectStockLocationList.do', { locgb : '02'}, AUIGrid.getCellValue(myGridID ,rowid,'rdccode'),'mrdccode', 'S' , '');
        
        
        if (AUIGrid.getCellValue(myGridID ,rowid,'whlocgb') == '01'  || AUIGrid.getCellValue(myGridID ,rowid,'whlocgb') == '05'){
        	$("#mcdccode").prop("disabled" , true);
        	$("#mrdccode").prop("disabled" , true);
        	$("#plant").prop("disabled" , false);
        	$("#slplant").prop("disabled" , false);
        }else if (AUIGrid.getCellValue(myGridID ,rowid,'whlocgb') == '02'){
            $("#mcdccode").prop("disabled" , false);
            $("#mrdccode").prop("disabled" , true);
            $("#plant").prop("disabled" , false);
            $("#slplant").prop("disabled" , true);
        }else{
            $("#mcdccode").prop("disabled" , false);
            $("#mrdccode").prop("disabled" , false);
            $("#plant").prop("disabled" , true);
            $("#slplant").prop("disabled" , true);
        }
    	
        $( "#editWindow" ).show();
    }
    
    
  function fn_insertWare(){
	  
	    $("#iplant").val('');
        $("#islplant").val('');

	    doDefCombo(stockgradecomboData, '' ,'instockgrade', 'S', '');
	    
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch1', 'S' , ''); //브런치 등록
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch2', 'S' , ''); //브런치 등록
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch3', 'S' , ''); //브런치 등록
        
        
        fn_addMaddr();
        
        var paramdata = { groupCode : '339' , orderValue : 'CODE'};
        doGetComboData('/common/selectCodeList.do', paramdata, '','ilocationtype', 'S' , '');
        
        paramdata = { locgb:'01'}; // session 정보 등록 
        doGetComboData('/common/selectStockLocationList.do', paramdata, '','icdccode', 'S' , '');
        doGetComboData('/common/selectStockLocationList.do', { locgb : '02'}, '','irdccode', 'S' , '');
    }
  function rdccodeFunc(){
	    doGetComboCodeId('/common/selectStockLocationList.do', { locgb : '02' , cdcloc:$("#icdccode").val()}, '','irdccode', 'S' , '');
  }
  function fn_deleteWare(rowid){      
	  var locid=AUIGrid.getCellValue(myGridID ,rowid,'locid');	
     // var param = "?locid="+locid;
      Common.ajax("GET", "/logistics/organization/locationDelete.do", {"locid":locid}, function(result) { 
    	  Common.alert(result.message);
        $("#search").click();
      }, function(jqXHR, textStatus, errorThrown) {
          Common.alert("실패하였습니다.");
          
          alert(jqXHR.responseJSON.message);
          
      });    
  }    
  function inValidation(){
	    
	   var inwarecd     = $("#inwarecd").val().trim();
	   var inwarenm     = $("#inwarenm").val().trim();
	   var instockgrade = $("#instockgrade").val().trim();
	   var inwarebranch = $("#inwarebranch1").val().trim();
	   var incontact1   = $("#incontact1").val().trim();  
	   var incontact2   = $("#incontact2").val().trim();   

	   fn_locchk(inwarecd);
	  	   
	   if(locchkcnt > 0){
		   Common.alert('Location Code Duplicate,Please Check code!');
		   return false;
	   }
	   
	   if(inwarecd == null || inwarecd == "" ){
           Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           $("#inwarecd").focus();
           return false;
     }  
	   if(inwarenm == null || inwarenm == "" ){
           Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           $("#inwarenm").focus();
           return false;
     }
	   if(instockgrade == null || instockgrade == "" ){
           Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           $("#instockgrade").focus();
           return false;
     }
	 
	   if(inwarebranch == null || inwarebranch == "" ){
           Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           $("#inwarebranch1").focus();
           return false;
     }
       
       if(incontact1 == null || incontact1 == "" ){
           Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           $("#incontact1").focus();
           return false;
     }

  	   if(isNaN(incontact1) || isNaN(incontact2) ){
           Common.alert('Contact number is invalid. Please key in only number in contact field.'); 
           return false;
     }   
  	   return true;
  }
   

    function fn_updateGridRow(){
    	//AUIGrid.setSelectionByIndex(myGridID, selcell , 3);
    	var item = {};
    	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        
        item.loccd   = $("#mwarecd").val();
        item.locdesc = $("#mwarenm").val();
        item.locdtl  = $("#maddr1").val();
        item.loctel1  = $("#mcontact1").val();
        item.loctel2  = $("#mcontact2").val();
        item.locgrad  = $("#mstockgrade").val();
        item.areaid   = $("#mareaId").val();
        item.street   = $("#streetDtl").val();
        item.locbranch1 = $("#mwarebranch1").val();
        item.locbranch2 = $("#mwarebranch2").val();
        item.locbranch3 = $("#mwarebranch3").val();
        item.whlocgb = $("#locationtype").val();
        
        if ($("#pdchk").is(":checked")) item.serialpdchk = 'Y';else item.serialpdchk = '';
        if ($("#ftchk").is(":checked")) item.serialftchk = 'Y';else item.serialftchk = '';
        if ($("#ptchk").is(":checked")) item.serialptchk = 'Y';else item.serialptchk = '';
        
        item.cdccode = $("#mcdccode").val();
        item.rdccode = $("#mrdccode").val();
        
        item.plant   = $("#plant").val();
        item.slplant = $("#slplant").val();
        
        AUIGrid.updateRow(myGridID, item, selectedItem[0]);
    }
    
    function fn_locDetail(locid){
    	var param = "?locid="+locid;
    	$.ajax({
            type : "POST",
            url : "/logistics/organization/locationDetail.do"+param,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(_data) {
                var data = _data.data;
                var stock = _data.stock;
                fn_detailView(_data);
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("실패하였습니다.");
            }
        });
    }
    
    function getLocationListAjax() {
        var param = $('#searchForm').serialize();
        console.log(param);
        Common.showLoader();
        $.ajax({
            type : "POST",
            url : "/logistics/organization/LocationList.do?"+param,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                var gridData = data;
                
                AUIGrid.setGridData(myGridID, gridData.data);
            },
            error: function(jqXHR, textStatus, errorThrown){
            	Common.alert("Fail : " + jqXHR.responseJSON.message);
            },
            complete: function(){
            	Common.removeLoader();
            }
        });       
    }
     
    
    function f_multiCombo(){
        $(function() {
            $('#loctype').change(function() {
            
            }).multipleSelect({
                selectAll: true, // 전체선택 
                width: '80%'
            });
        });
    }        
     function fn_updateCancel(){
    	 $( "#editWindow" ).hide();
    	 $('#modForm')[0].reset();
     }
     
     function fn_insertGrid(){
    	 
    	 if(inValidation()){
    		 
    		 console.log($("#insForm").serialize());
             //$('#instockgrade').attr("disabled",false)
               Common.ajax("GET", "/logistics/organization/insLocation.do", $("#insForm").serialize(), function(result) { 
                Common.alert(""+result.message+"</br> Created WHID: "+result.data);             	   
                //Common.alert(result.message);
                $( "#registWindow" ).hide();
                $('#insForm')[0].reset();
                
                }, function(jqXHR, textStatus, errorThrown) {
                    Common.alert("실패하였습니다.");
                    
                    alert(jqXHR.responseJSON.message);
                    
                });        
        
           }
    	 
     }
     function fn_insertCancel(){
         $( "#registWindow" ).hide();
     }

     
     function fn_itempopList(data){
    	 
    	 var rtnVal = data[0].item.loccd;
    	 $("#loccd").val(rtnVal);
     }
     
     function fn_plantchk(id , take){
    	 
    	 if($("#"+id).val() == '03'){
    		 $("#"+take+"plant").val('6000');
    		 $("#"+take+"plant").attr("disabled"   , true);
    		 $("#"+take+"slplant").attr("disabled" , true);
         }else if($("#"+id).val() == '04'){
             $("#"+take+"plant").val('5000');
             $("#"+take+"plant").attr("disabled"   , true);
             $("#"+take+"slplant").attr("disabled" , true);
         }else{
        	 $("#"+take+"plant").attr("disabled"   , false);
        	 if ($("#"+id).val() == '02'){
        		 $("#"+take+"slplant").attr("disabled" , true);
        	 }else{
        		 $("#"+take+"slplant").attr("disabled" , false);
        	 }        	 
         }
     }
     
//      function fn_deleteAjax(rowid) {
//     	 alert("rowid :   "+rowid);
//       fn_deleteWare(rowid);
// 	}

    function fn_locchk(loccode){
        var param = {"loccode" : loccode};
        
        Common.ajaxSync("POST", "/logistics/organization/locationchk.do", param, function(_data) {   	
             locchkcnt = _data.loccnt;
        });
        
    }
 
</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Location</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Location</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li> 
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">
<input type="hidden" id="sUrl" name="sUrl">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Code</th>
    <td>
    <input type="text" id="loccd" name="loccd" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Branch</th>
    <td>
    <select class="w100p" id="branchid" name="branchid">
    </select>
    </td>
    <th scope="row">Status</th>
    <td>
    <select id="status" class="w100p" name="status">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Name</th>
    <td colspan="5">
    <input type="text" id="locdesc" name="locdesc" title="Name" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Location Type</th>
    <td>
        <select class="w100p" id="loctype" name="loctype"></select>
    </td>
    <th scope="row">Location Grade</th>
    <td>
        <select class="w100p" id="locgrad" name="locgrad"></select>
    </td>
    <td colspan='2'></td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

<%--     <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.up' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li>
<%--     <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="height:500px"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

<div class="popup_wrap" id="editWindow" style="display:none"><!-- popup_wrap start -->
<header class="pop_header"><!-- pop_header start -->
<h1>Location Information</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="modForm" name="modForm" method="POST">
<input type="hidden" id="mareaId" name="mareaId">
<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Status</th>
    <td colspan="3"><span  id="mstatus"  class="w100p"></span></td>
</tr>
<tr>
    <th scope="row">Location Code</th>
    <td><input type="text" name="mwarecd" id="mwarecd"  class="w100p"/></td>    
    <th scope="row">Serial Check</th>
    <td>
        <label><input type="checkbox" id="pdchk" name="pdchk"/><span>Product</span></label>
        <label><input type="checkbox" id="ftchk" name="ftchk"/><span>Filter</span></label>
        <label><input type="checkbox" id="ptchk" name="ptchk"/><span>Parts</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Location Name</th>
    <td colspan="3"><input type="text" name="mwarenm" id="mwarenm" class="w100p"/></td>
</tr>
<tr>
    <th scope="row">CDC CODE</th>
    <td><select id="mcdccode" class="w100p"></select></td>
    <th scope="row">RDC CODE</th>
    <td><select id="mrdccode" class="w100p"></select></td>
</tr>
<tr>
    <th scope="row">Location Type</th>
    <td><select id="locationtype" name="locationtype"  class="w100p" onchange="fn_plantchk(this.id , '')"></select></td>
    <th scope="row">Location Grade</th>
    <td><select id="mstockgrade" class="w100p"></select></td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td colspan='3'><select id="mwarebranch1" style="width: 273px!important"  ></select><select id="mwarebranch2" style="width: 273px!important" class="ml5"></select><select id="mwarebranch3" style="width: 273px!important" class="ml5"></select></td>
</tr>
<tr>
    <th scope="row">Contact No (1)</th>
    <td><input type="text" name="mcontact1" id="mcontact1"  class="w100p"/></td>
    <th scope="row">Contact No (2)</th>
    <td><input type="text" name="mcontact2" id="mcontact2"  class="w100p"/></td>
</tr>
<tr>
    <th scope="row">Plant in ECC</th>
    <td >
        <input type="text" title="" id="plant" name="plant" placeholder="" class="w100p" />
    </td>
    <th scope="row">S/L in ECC</th>
    <td >
        <input type="text" title="" id="slplant" name="slplant" placeholder="" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Street search<span class="must">*</span></th>
    
    <td colspan='3'>
    <div class="search_100p"><!-- search_100p start -->
        <input type="text" title="" id="searchSt" name="searchSt" placeholder="" class="w100p" /><a href="#" onclick="fn_addrSearch()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
    </div>
    </td>    
    
</tr>
<tr>
    <th scope="row">Address Detail</th>
    <td colspan="3"><input type="text" id="maddr1" name="maddr1" class="w100p"/></td>
</tr>
<tr>
	<th scope="row" colspan="4">Magic Address Street</th>
	<!-- <td colspan="3"> -->
</tr>
<tr>
   <th scope="row">Area(4)<span class="must">*</span></th>
	<td colspan="3">
	<select class="w100p" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId('m')"></select> 
	</td>
</tr>
<tr>
	 <th scope="row">City(2)<span class="must">*</span></th>
	<td>
	<select class="w100p" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value , 'm')"></select>  
	</td>
	<th scope="row">PostCode(3)<span class="must">*</span></th>
	<td>
	<select class="w100p" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value , 'm')"></select>
	</td>
</tr>
<tr>
	<th scope="row">State(1)<span class="must">*</span></th>
	<td>
	<select class="w100p" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value , 'm')"></select>
	</td>
	<th scope="row">Country<span class="must">*</span></th>
	<td>
	<input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
	</td>
</tr>
</tbody>
</table><!-- table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_updateGridRow();">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_updateCancel();">CANCEL</a></p></li>
</ul>
</form>

</section>
</div>

<div class="popup_wrap" id="registWindow" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Location Information</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="insForm" name="insForm" method="POST">
<input type="hidden" name="extype" id="extype" value="INS">
<input type="hidden" name="iareaId" id="iareaId">
<table class="type1">
<caption>search table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Location Code</th>
    <td colspan="3"><input type="text" name="inwarecd" id="inwarecd" maxlength="10" class="w100p" /></td>    
</tr>
<tr>
    <th scope="row">Location Name</th>
    <td colspan="3"><input type="text" name="inwarenm" id="inwarenm" class="w100p"/></td>
</tr>
<tr>
    <th scope="row">CDC_CODE</th>
    <td><select id="icdccode" name="icdccode" class="w100p"></select></td>
    <th scope="row">RDC_CODE</th>
    <td><select id="irdccode" name="irdccode" class="w100p"></select></td>
</tr>
<tr>
    <th scope="row">Location Type</th>
    <td><select id="ilocationtype" name="ilocationtype"  class="w100p" onchange="fn_plantchk(this.id , 'i')"></select></td>
    <th scope="row">Location Grade</th>
    <td><select id="instockgrade" name="instockgrade" class="w100p"></select></td>
</tr>
<tr>
    <th scope="row">Plant in ECC</th>
    <td >
        <input type="text" title="" id="iplant" name="iplant" placeholder="" class="w100p" />
    </td>
    <th scope="row">S/L in ECC</th>
    <td >
        <input type="text" title="" id="islplant" name="islplant" placeholder="" class="w100p" />
    </td>
</tr>
<tr> 
    <th scope="row">Branch</th>
    <td colspan="3">
        <select id="inwarebranch1" name="inwarebranch1" style="width: 273px!important" ></select> <select id="inwarebranch2" name="inwarebranch2"  style="width: 273px!important" class="ml5"></select> <select id="inwarebranch3" name="inwarebranch3" style="width: 273px!important" class="ml5"></select>
    </td>
</tr>
<tr> 
    <th scope="row">Serial Check</th>
    <td>
        <label><input type="checkbox" id="ipdchk" name="ipdchk"/><span>Product</span></label>
        <label><input type="checkbox" id="iftchk" name="iftchk"/><span>Filter</span></label>
        <label><input type="checkbox" id="iptchk" name="iptchk"/><span>Parts</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Street search<span class="must">*</span></th>
    <td colspan='3'>
     <div class="search_100p"><!-- search_100p start -->
        <input type="text" title="" id="isearchSt" name="isearchSt" placeholder="" class="w100p" /><a href="#" onclick="fn_addrSearch1()" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
     </div>
    </td>    
</tr>
<tr>
    <th scope="row">Address Detail</th>
    <td colspan="3"><input type="text" id="iaddrdtl" name="iaddrdtl" class="w100p"/></td>
</tr>
 <tr>
    <th scope="row">Country</th>
    <td><input type="text" title="" id="iCountry" name="iCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/></td>
    <th scope="row">State</th>
    <td><select class="w100p" id="iState"  name="iState" onchange="javascript : fn_selectState(this.value , 'i')"></select></td>
</tr>
<tr>
    <th scope="row">City</th>
    <td><select class="w100p" id="iCity"  name="iCity" onchange="javascript : fn_selectCity(this.value , 'i')"></select></td>
    <th scope="row">Postcode</th>
    <td><select class="w100p" id="iPostCd"  name="iPostCd" onchange="javascript : fn_selectPostCode(this.value , 'i')"></select></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td><select class="w100p" id="iArea"  name="iArea" onchange="javascript : fn_getAreaId('i')"></select></td>
    <th scope="row">Street</th>
    <td><input type="text" title="" id="istreet" name="istreet" placeholder="Detail Address" class="w100p"  /></td>
</tr>  
<tr>
    <th scope="row">Contact No (1)</th>
    <td><input type="text" name="incontact1" id="incontact1" class="w100p" /></td>
    <th scope="row">Contact No (2)</th>
    <td><input type="text" name="incontact2" id="incontact2" class="w100p" /></td>
</tr> 
</tbody>
</table>

<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_insertGrid();">SAVE</a></p></li> 
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_insertCancel();">CANCEL</a></p></li>
</ul>
</form>

</section>
</div>

</section><!-- content end -->
<script type="text/javaScript" language="javascript">
	function fn_addrSearch(){
         if($("#searchSt").val() == ''){
             Common.alert("Please search.");
             return false;
         }
         Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#modForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
     }
	
	function fn_addrSearch1(){
        if($("#isearchSt").val() == ''){
            Common.alert("Please search.");
            return false;
        }
        Common.popupDiv('/sales/customer/searchMagicAddressPop.do' , $('#insForm').serializeJSON(), null , true, '_searchDiv'); //searchSt
    }
     
     function fn_addMaddr(marea, mcity, mpostcode, mstate, areaid, miso){
         
         if(marea != "" && mpostcode != "" && mcity != "" && mstate != "" && areaid != "" && miso != ""){
             
             $("#"+pagestate+"Area").attr({"disabled" : false  , "class" : "w100p"});
             $("#"+pagestate+"City").attr({"disabled" : false  , "class" : "w100p"});
             $("#"+pagestate+"PostCd").attr({"disabled" : false  , "class" : "w100p"});
             $("#"+pagestate+"State").attr({"disabled" : false  , "class" : "w100p"});
             
             //Call Ajax
            
             CommonCombo.make(pagestate+'State', "/sales/customer/selectMagicAddressComboList", '' , mstate, optionState);
             
             var cityJson = {groupCode : mstate};
             CommonCombo.make(pagestate+'City', "/sales/customer/selectMagicAddressComboList", cityJson, mcity , optionCity);
             
             var postCodeJson = {state : mstate , city : mcity}; //Condition
             CommonCombo.make(pagestate+'PostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, mpostcode , optionPostCode);
             
             var areaJson = {state : mstate , city : mcity , postcode : mpostcode}; //Condition
             CommonCombo.make(pagestate+'Area', "/sales/customer/selectMagicAddressComboList", areaJson, marea , optionArea);
             
             
             $("#"+pagestate+"areaId").val(areaid);
             $("#_searchDiv").remove();
         }else{
             Common.alert("Please check your address.");
         }
     }
     
   //Get Area Id
     function fn_getAreaId(d){
         
         var statValue = $("#"+d+"State").val();
         var cityValue = $("#"+d+"City").val();
         var postCodeValue = $("#"+d+"PostCd").val();
         var areaValue = $("#"+d+"Area").val();
         
         
         
         if('' != statValue && '' != cityValue && '' != postCodeValue && '' != areaValue){
             
             var jsonObj = { statValue : statValue ,
                                   cityValue : cityValue,
                                   postCodeValue : postCodeValue,
                                   areaValue : areaValue
                                 };
             Common.ajax("GET", "/sales/customer/getAreaId.do", jsonObj, function(result) {
            	 console.log(result);
                 if (result != null){
                	 $("#"+d+"areaId").val(result.areaId);
                 }else{
                	 Common.alert("Address research please!");
                 }
             });
             
         }
         
     }

	 function fn_selectCity(selVal , d){
        
        var tempVal = selVal;
        
        if('' == selVal || null == selVal){
           
            $("#"+d+"PostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
            $("#"+d+"PostCd").val('');
            
            $("#"+d+"Area").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
            $("#"+d+"Area").val('');
            
        }else{
            
            $("#"+d+"PostCd").attr({"disabled" : false  , "class" : "w100p"});
            
            $("#"+d+"Area").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
            $("#"+d+"Area").val('');
            
            //Call ajax
            var postCodeJson = {state : $("#"+d+"State").val() ,city : tempVal}; //Condition
            CommonCombo.make(d+'PostCd', "/sales/customer/selectMagicAddressComboList", postCodeJson, '' , optionPostCode);
        }
        
    }

	function fn_selectPostCode(selVal , d){
        
        var tempVal = selVal;
        
        if('' == selVal || null == selVal){
           
            $("#"+d+"Area").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
            $("#"+d+"Area").val('');
            
        }else{
            
            $("#"+d+"Area").attr({"disabled" : false  , "class" : "w100p"});
            
            //Call ajax
            var areaJson = {state : $("#"+d+"State").val(), city : $("#"+d+"City").val() , postcode : tempVal}; //Condition
            CommonCombo.make(d+'Area', "/sales/customer/selectMagicAddressComboList", areaJson, '' , optionArea);
        }
        
    }

	function fn_selectState(selVal , d){
        
        var tempVal = selVal;
        
        if('' == selVal || null == selVal){
            //전체 초기화
            fn_initAddress(d);   
            
        }else{
            
            $("#"+d+"City").attr({"disabled" : false  , "class" : "w100p"});
            
            $("#"+d+"PostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
            $("#"+d+"PostCd").val('');
            
            $("#"+d+"Area").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
            $("#"+d+"Area").val('');
            
            //Call ajax
            var cityJson = {state : tempVal}; //Condition
            CommonCombo.make(d+'City', "/sales/customer/selectMagicAddressComboList", cityJson, '' , optionCity);
        }
        
    }
	
	function fn_initAddress(d){
        
        $("#"+d+"PostCd").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        $("#"+d+"PostCd").val('');
        
        $("#"+d+"City").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        $("#"+d+"City").val('');
        
        $("#"+d+"Area").attr({"disabled" : "disabled"  , "class" : "w100p disabled"});
        $("#"+d+"Area").val('');
   }
</script>
