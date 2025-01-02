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
var columnLayout = [{dataField: "locid",headerText :"<spring:message code='log.head.whid'/>"               ,width:  "8%"      ,height:30 , visible:false},
							{dataField: "loccd",headerText :"Location Code"               ,width:  110   ,height:30 , visible:true},
							{dataField: "locdesc",headerText :"Location Name"       ,width: 280    ,height:30 , visible:true},
							{dataField: "locdtl",headerText :"<spring:message code='log.head.locaddr1'/>"          ,width:120   ,height:30 , visible:false},
							{dataField: "areaid",headerText :"<spring:message code='log.head.locarea'/>"            ,width:120   ,height:30 , visible:false},
							{dataField: "street",headerText :"<spring:message code='log.head.street'/>"          ,width:120   ,height:30 , visible:false},
							{dataField: "loctel1",headerText :"<spring:message code='log.head.loctel1'/>"           ,width:90    ,height:30 , visible:false},
							{dataField: "loctel2",headerText :"<spring:message code='log.head.loctel2'/>"           ,width:120   ,height:30 , visible:false},
							{dataField: "locbranch1",headerText :"<spring:message code='log.head.loc_branch'/>"      ,width:100   ,height:30 , visible:false},
							{dataField: "locbranch2",headerText :"<spring:message code='log.head.loc_branch'/>"      ,width:100   ,height:30 , visible:false},
							{dataField: "locbranch3",headerText :"<spring:message code='log.head.loc_branch'/>"      ,width:100   ,height:30 , visible:false},
							{dataField: "whlocgb",headerText :"<spring:message code='log.head.locationtype'/>"    ,width:100   ,height:30 , visible:false},
							{dataField: "whlocgbnm",headerText :"<spring:message code='log.head.locationtype'/>"      ,width:   120    ,height:30 , visible:true},
							{dataField: "whloclane",headerText :"Location Lane"       ,width:120   ,height:30 , visible:true},
							{dataField: "loctype",headerText :"<spring:message code='log.head.loctype'/>"           ,width:100   ,height:30 , visible:false},
							{dataField: "locuserid",headerText :"<spring:message code='log.head.locuserid'/>"         ,width:100   ,height:30 , visible:false},
							{dataField: "locupddt",headerText :"<spring:message code='log.head.locupddt'/>"        ,width:100   ,height:30 , visible:false},
							{dataField: "code2",headerText :"<spring:message code='log.head.code2'/>"             ,width:100   ,height:30 , visible:false},
							{dataField: "desc2",headerText :"<spring:message code='log.head.desc2'/>"             ,width:100   ,height:30 , visible:false},
							{dataField: "areanm",headerText :"<spring:message code='log.head.areanm'/>"          ,width:100   ,height:30 , visible:false},
							{dataField: "postcd",headerText :"<spring:message code='log.head.postcd'/>"          ,width:100   ,height:30 , visible:false},
							{dataField: "code",headerText :"<spring:message code='log.head.code'/>"            ,width:100   ,height:30 , visible:false},
							{dataField: "name",headerText :"<spring:message code='log.head.name'/>"            ,width:100   ,height:30 , visible:false},
							{dataField: "countrynm",headerText :"<spring:message code='log.head.countrynm'/>"         ,width:100   ,height:30 , visible:false},
							{dataField: "branchcd",headerText :"<spring:message code='log.head.branchcode'/>"          ,width:120   ,height:30 , visible:true},
							{dataField: "branchnm",headerText :"<spring:message code='log.head.branchname'/>"            ,width:    220    ,height:30 , visible:true},
							{dataField: "dcode",headerText :"<spring:message code='log.head.dcode'/>"             ,width:100   ,height:30 , visible:false},
							{dataField: "descr",headerText :"<spring:message code='log.head.descr'/>"             ,width:100   ,height:30 , visible:false},
							{dataField: "codenm",headerText :"<spring:message code='log.head.type'/>"              ,width: 100   ,height:30 , visible:false},
							{dataField: "statnm",headerText :"<spring:message code='log.head.status'/>"          ,width:    100    ,height:30 , visible:true},
							{dataField: "locgrad",headerText :"<spring:message code='log.head.locationgrade'/>"  ,width:120   ,height:30 , visible:true},
							{dataField: "locstus",headerText :"<spring:message code='log.head.locstus'/>"           ,width:100   ,height:30 , visible:false},
							{dataField: "user_name",headerText :"<spring:message code='log.head.nser_name'/>"         ,width:100   ,height:30 , visible:false},
							{dataField: "cdccode",headerText :"<spring:message code='log.head.cdc_code'/>"         ,width:100   ,height:30 , visible:false},
							{dataField: "rdccode",headerText :"<spring:message code='log.head.rdc_code'/>"         ,width:100   ,height:30 , visible:false},
							{dataField: "plant",headerText :"<spring:message code='log.head.plant'/>"             ,width:100   ,height:30 , visible:false},
							{dataField: "slplant",headerText :"<spring:message code='log.head.s/l'/>"             ,width:100   ,height:30 , visible:false},
							{dataField: "rem", visible:false},
							{dataField: "serialpdchk",headerText :"Serial Check – Stock"  ,width:150   ,height:30 , visible:true},
                            {dataField: "serialftchk",headerText :"Serial Check – Filter"  ,width:150   ,height:30 , visible:true},
                            {dataField: "serialptchk",headerText :"Serial Check – Spare Part"  ,width:180   ,height:30 , visible:true},
                            {dataField: "serialRequireChkYn",headerText :"Serial Required Check Y/N"  ,width:10   ,height:30 , visible:false},
                            {dataField: "haChk",headerText :"Home Appliance"  ,width:180   ,height:30 , visible:true},
                            {dataField: "hcChk",headerText :"Home Care"  ,width:180   ,height:30 , visible:true}
                       ];

var detailLayout = [{dataField: "stkid",headerText :"<spring:message code='log.head.stkid'/>"             ,width:   "12%"    ,height:30 , visible:false},
                    {dataField: "stkcd",headerText :"<spring:message code='log.head.code'/>"               ,width:  "15%"    ,height:30 , visible:true},
                    {dataField: "stkdesc",headerText :"<spring:message code='log.head.description'/>"       ,width: "40%"    ,height:30 , visible:true},
                    {dataField: "qty",headerText :"<spring:message code='log.head.balance'/>"           ,width: "15%"    ,height:30 , visible:true},
                    {dataField: "statname",headerText :"<spring:message code='log.head.status'/>"            ,width:    "15%"    ,height:30 , visible:true},
                    {dataField: "unclamed",headerText :"<spring:message code='log.head.unclamed'/>"        ,width:  "15%"    ,height:30 , visible:true},
                    {dataField: "typename",headerText :"<spring:message code='log.head.typename'/>"        ,width:120 ,height:30 , visible:false},
                    {dataField: "catename",headerText :"<spring:message code='log.head.catename'/>"        ,width:120 ,height:30 , visible:false},
                    {dataField: "stkcateid",headerText :"<spring:message code='log.head.stkcateid'/>"         ,width:120 ,height:30 , visible:false},
                    {dataField: "typeid",headerText :"<spring:message code='log.head.typeid'/>"          ,width:120 ,height:30 , visible:false},
                    {dataField: "statuscd",headerText :"<spring:message code='log.head.statuscd'/>"        ,width:90  ,height:30 , visible:false}
                       ];


var gridoptions = {showStateColumn : false , editable : false, usePaging : false, showFooter : false, useGroupingPanel : false };


$(document).ready(function(){

		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);

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
            console.log(event);
            if (event.rowIndex > -1){
                fn_modyWare(event.rowIndex);
            }else{
                Common.alert('Please select record.');
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

            if (selectedItem[0] > -1){
                fn_modyWare(selectedItem[0]);
            }else{
            //Common.alert('Choice Data please..');
            Common.alert('Please select data to update.');
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
            Common.alert('Please select record for deletion.');
            }

        });
        // Commented for removing relationship between CDC & RDC code selection by Hui Ding, 17/9/2019
        /* $("#icdccode").change(function(){
        	rdccodeFunc();
        }); */

        $("#irdccode ,#mrdccode").change(function(){

        	if($("#ilocationtype").val() == '03' || $("#ilocationtype").val() == '04' || $("#ilocationtype").val() == '09'){ // KR-OHK DT Add
        		var irdcCode = $("#irdccode").val();
                $("#islplant").val(irdcCode);
        	} else if ($("#locationtype").val() == '03' || $("#locationtype").val() == '04' || $("#locationtype").val() == '09'){ // KR-OHK DT Add
        		var rdcCode = $("#mrdccode").val();
                $("#slplant").val(rdcCode);
        	}
        });
    });

    function fn_modyWare(rowid){

    	console.log(AUIGrid.getCellValue(myGridID ,rowid,'locstus'));

    	if (AUIGrid.getCellValue(myGridID ,rowid,'whlocgbnm') != "CT")
    	{
    		$("#loclane").prop('disabled', true);
    	}
    	else
    	{
    		$("#loclane").prop('disabled', false);
    	}

    	$("#mwarecd").val(AUIGrid.getCellValue(myGridID ,rowid,'loccd'));
    	$("#mwarenm").val(AUIGrid.getCellValue(myGridID ,rowid,'locdesc'));
    	$("#maddr1").val(AUIGrid.getCellValue(myGridID ,rowid,'locdtl'));
    	$("#mcontact1").val(AUIGrid.getCellValue(myGridID ,rowid,'loctel1'));
    	$("#mcontact2").val(AUIGrid.getCellValue(myGridID ,rowid,'loctel2'));
    	$("#street").val(AUIGrid.getCellValue(myGridID ,rowid,'street'));
    	$("#mareaId").val(AUIGrid.getCellValue(myGridID ,rowid,'areaid'));
    	$("#plant").val(AUIGrid.getCellValue(myGridID ,rowid,'plant'));
    	$("#slplant").val(AUIGrid.getCellValue(myGridID ,rowid,'slplant'));
        $("#loclane").val(AUIGrid.getCellValue(myGridID ,rowid,'whloclane'));
        $("#rem").val(AUIGrid.getCellValue(myGridID ,rowid,'rem'));

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
    	doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , AUIGrid.getCellValue(myGridID ,rowid,'locbranch4'),'mwarebranch4', 'S' , '');
    	doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , AUIGrid.getCellValue(myGridID ,rowid,'locbranch5'),'mwarebranch5', 'S' , '');

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
    	// 20191122 KR-OHK Serial Required Check Y/N Add
    	if (AUIGrid.getCellValue(myGridID ,rowid,'serialRequireChkYn') == "Y"){
    		$("input:radio[name='serialRequireChkYn']:radio[value='Y']").prop("checked", true);
    	} else {
    		$("input:radio[name='serialRequireChkYn']:radio[value='N']").prop("checked", true);
    	}

    	// Added for Flagging CDC to be used in Homecare or Home Appliance platform. By Hui Ding, 2020-08-07
    	if (AUIGrid.getCellValue(myGridID, rowid, 'haChk') == "Y"){
    		$("#haChk").prop("checked" , true);
    	} else{
            $("#haChk").prop("checked" , false);
        }

    	if (AUIGrid.getCellValue(myGridID, rowid, 'hcChk') == "Y"){
            $("#hcChk").prop("checked" , true);
        } else{
            $("#hcChk").prop("checked" , false);
        }

    	// Added RFD doc no. when create new CDC, RDC, CDC&RDC location. not allow to edit. Hui Ding, 01/03/2022
    	$("#docNo").val(AUIGrid.getCellValue(myGridID, rowid, 'docNo'));

    	/*
    	doGetComboData('/common/selectStockLocationList.do', { locgb : '01'}, AUIGrid.getCellValue(myGridID ,rowid,'cdccode'),'mcdccode', 'S' , '');
    	doGetComboData('/common/selectStockLocationList.do', { locgb : '02'}, AUIGrid.getCellValue(myGridID ,rowid,'rdccode'),'mrdccode', 'S' , '');
        */
    	doGetComboData('/common/selectStockLocationList.do', { stoIn : '01,05'}, AUIGrid.getCellValue(myGridID ,rowid,'cdccode'),'mcdccode', 'S' , '');
    	doGetComboData('/common/selectStockLocationList.do', { stoIn : '02,05'}, AUIGrid.getCellValue(myGridID ,rowid,'rdccode'),'mrdccode', 'S' , '');

        if (AUIGrid.getCellValue(myGridID ,rowid,'whlocgb') == '01'  || AUIGrid.getCellValue(myGridID ,rowid,'whlocgb') == '05'){
        	$("#mcdccode").prop("disabled" , true);
        	$("#mrdccode").prop("disabled" , true);
        	$("#plant").prop("disabled" , false);
        	$("#slplant").prop("disabled" , false);
        }else if (AUIGrid.getCellValue(myGridID ,rowid,'whlocgb') == '02'){
            $("#mcdccode").prop("disabled" , false);
            //$("#mrdccode").prop("disabled" , true);
            $("#mrdccode").prop("disabled" , false);
            $("#plant").prop("disabled" , false);
            $("#slplant").prop("disabled" , true);
        }else{
            $("#mcdccode").prop("disabled" , false);
            $("#mrdccode").prop("disabled" , false);
            $("#plant").prop("disabled" , true);
            $("#slplant").prop("disabled" , true);
        }

        $( "#editWindow" ).show();
        doGetComboData('/logistics/organization/selectLocStatusList.do','',AUIGrid.getCellValue(myGridID ,rowid,'locstus'),'mstatus', 'S' , '');
    }


  function fn_insertWare(){

	    $("#iplant").val('');
        $("#islplant").val('');

	    doDefCombo(stockgradecomboData, '' ,'instockgrade', 'S', '');

        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch1', 'S' , ''); //브런치 등록
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch2', 'S' , ''); //브런치 등록
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch3', 'S' , ''); //브런치 등록
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch4', 'S' , ''); //브런치 등록
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch5', 'S' , ''); //브런치 등록

        $("#irem").val('');

        fn_addMaddr();

        var paramdata = { groupCode : '339' , orderValue : 'CODE'};
        doGetComboData('/common/selectCodeList.do', paramdata, '','ilocationtype', 'S' , '');

        paramdata = { locgb:'01'}; // session 정보 등록
        doGetComboData('/common/selectStockLocationList.do', paramdata, '','icdccode', 'S' , '');
        doGetComboData('/common/selectStockLocationList.do', { locgb : '02'}, '','irdccode', 'S' , '');
    }

  //Commented for removing relationship between CDC & RDC code selection by Hui Ding, 17/9/2019
  /* function rdccodeFunc(){
	    doGetComboCodeId('/common/selectStockLocationList.do', { locgb : '02' , cdcloc:$("#icdccode").val()}, '','irdccode', 'S' , '');
  } */

  function fn_deleteWare(rowid){
	  var locid=AUIGrid.getCellValue(myGridID ,rowid,'locid');
     // var param = "?locid="+locid;
      Common.ajax("GET", "/logistics/organization/locationDelete.do", {"locid":locid}, function(result) {
    	  Common.alert(result.message);
        $("#search").click();
      }, function(jqXHR, textStatus, errorThrown) {
          //Common.alert("실패하였습니다.");
          Common.alert('Failed to delete record.');

          alert(jqXHR.responseJSON.message);

      });
  }
  function validate(action){

	   var warecd;
	   var warenm;
	   var stockgrade;
	   var warebranch1;
	   var warebranch2;
	   var warebranch3;
	   var warebranch4;
       var warebranch5;
	   var contact1;
	   var contact2;
	   var plant;
	   var slPlant;
	   var country;
	   var state;
	   var city;
	   var postcode;
	   var area;
	   var addrDtl;

	   var locType;
	   var hcChk;
	   var haChk;

	   var docNo;

	   if (action == "i"){
		   warecd = $("#inwarecd").val().trim();
		   warenm = $("#inwarenm").val().trim();
		   stockgrade = $("#instockgrade").val().trim();
		   warebranch1 = $("#inwarebranch1").val().trim();
		   warebranch2 = $("#inwarebranch2").val().trim();
		   warebranch3 = $("#inwarebranch3").val().trim();
		   warebranch4 = $("#inwarebranch4").val().trim();
           warebranch5 = $("#inwarebranch5").val().trim();
		   contact1 = $("#incontact1").val().trim();
		   contact2 = $("#incontact2").val().trim();
		   country = $("#iCountry").val().trim();
		   city = $("#iCity").val().trim();
		   state = $("#iState").val().trim();
		   postcode = $("#iPostCd").val().trim();
		   area = $("#iareaId").val().trim();
		   locType = $("#ilocationtype").val().trim();
		   addrDtl = $("#iaddrdtl").val().trim();
		   hcChk = $("#ihcChk").is(":checked");
		   haChk = $("#ihaChk").is(":checked");
		   docNo = $("#inDocNo").val().trim();

		   fn_locchk(warecd);

		   if(locchkcnt > 0){
	           Common.alert('Duplicated Location Code.');
	           return false;
		   }

		   if (locType == '01' || locType == '02' || locType == '05') { // CDC, RDC, CDC&RDC type

			// Added for validating RFD doc no during creation of RDC, CDC, CDC&RDC. Hui Ding. 24/02/2022
	           if (docNo == null || docNo == ""){
	               Common.alert('Supporting doc no. is required for creating location with type CDC, RDC and CDC&RDC.');
	               return false;
	           } else {
	               var pattern = /^[A-Za-z]+\-\d{4}\-\d{4}$/;
	               if (!pattern.test(docNo)) {
	                   Common.alert("Invalid Doc No.");
	                 return false;
	               }
	           }
		   }

	   } else if (action == "m"){
		   warecd = $("#mwarecd").val().trim();
           warenm = $("#mwarenm").val().trim();
           stockgrade = $("#mstockgrade").val().trim();
           warebranch1 = $("#mwarebranch1").val().trim();
           warebranch2 = $("#mwarebranch2").val().trim();
           warebranch3 = $("#mwarebranch3").val().trim();
           warebranch4 = $("#mwarebranch4").val().trim();
           warebranch5 = $("#mwarebranch5").val().trim();
           contact1 = $("#mcontact1").val().trim();
           contact2 = $("#mcontact2").val().trim();
           plant = $("#plant").val();
           slPlant = $("#slplant").val();
           country = $("#mCountry").val().trim();
           city = $("#mCity").val().trim();
           state = $("#mState").val().trim();
           postcode = $("#mPostCd").val().trim();
           area = $("#mareaId").val().trim();
           locType = $("#locationtype").val().trim();
           addrDtl = $("#maddr1").val().trim();
           hcChk = $("#hcChk").is(":checked");
           haChk = $("#haChk").is(":checked");


           if ($("#plant").val() == null || $("#plant").val() == undefined || $("#plant").val() == ""){
               Common.alert("Please enter Plant in ECC.");
               return false;
           }
	   }

	 if (warecd == null || warecd == "" ){
           //Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           Common.alert('Location Code is required.');
           //$("#inwarecd").focus();
           return false;
     } else if (warenm == null || warenm == "" ){
           //Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           Common.alert('Location Name is required.');
           //$("#inwarenm").focus();
           return false;
     } else if (stockgrade == null || stockgrade == "" ){
           //Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           Common.alert('Location Grade is required.');
           //$("#instockgrade").focus();
           return false;
     }else if(contact1 == null || contact1 == "" ){
           //Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           Common.alert('Please fill in at least 1 contact no.');
           //$("#incontact1").focus();
           return false;
     }else if(isNaN(contact1) || isNaN(contact2) ){
           Common.alert('Contact number is invalid. Please key in only number in contact field.');
           return false;
     } else if (locType != null && locType != "") {
    	 if (locType == '01' || locType == '02') { // CDC, RDC
    	   if ((country == null || country == "") || (city == null || city == "") || (state == null || state == "") ||
    			  (postcode == null || postcode == "") || (area == null || area == "") || (addrDtl == null || addrDtl == "")){
    		   Common.alert('Please complete the address.');
    		   return false;
    	   }

    	 }
    	/*  else if (locType == '05') { // CDC&RDC type
    		 console.log("hcChk: " + hcChk  + " \nhaChk: " + haChk);

    		 console.log("hcChk value : " +  $("#hcChk").val()  + " \nhaChk value: " + $("#haChk").val());

    		  if (hcChk == false && haChk == false){
    			  Common.alert('Please select Business Type for CDC&RDC type of location.');
                  return false;
    		  }
    	 } */

     } else {
    	 if((warebranch1 == null || warebranch1 == "") && (warebranch2 == null || warebranch2 == "") && (warebranch3 == null || warebranch3 == "")){
             //Common.alert('Some required fields are empty. Please fill up all the required fields. ');
             Common.alert('Reminder:\nIt is not recommend to leave Branch field empty.\nPlease edit it after saved.');
            // $("#inwarebranch1").focus();
             //return false;
       }
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
        item.street   = $("#street").val();
        item.locbranch1 = $("#mwarebranch1").val();
        item.locbranch2 = $("#mwarebranch2").val();
        item.locbranch3 = $("#mwarebranch3").val();
        item.locbranch4 = $("#mwarebranch4").val();
        item.locbranch5 = $("#mwarebranch5").val();
        item.whlocgb = $("#locationtype").val();
        item.locstus = $("#mstatus").val();
        item.loclane = $("#loclane").val();
        item.rem = $("#rem").val();
        item.serialRequireChkYn = $("input:radio[name=serialRequireChkYn]:checked").val();

        if ($("#pdchk").is(":checked")) item.serialpdchk = 'Y';else item.serialpdchk = '';
        if ($("#ftchk").is(":checked")) item.serialftchk = 'Y';else item.serialftchk = '';
        if ($("#ptchk").is(":checked")) item.serialptchk = 'Y';else item.serialptchk = '';

        // Added for Flagging CDC to be used in Homecare or Home Appliance platform. By Hui Ding, 2020-08-07
        if ($("#haChk").is(":checked")) item.haChk = 'Y';else item.haChk = '';
        if ($("#hcChk").is(":checked")) item.hcChk = 'Y';else item.hcChk = '';

        item.cdccode = $("#mcdccode").val();
        item.rdccode = $("#mrdccode").val();

        item.plant   = $("#plant").val();
        item.slplant = $("#slplant").val();

        if(validate("m")){
            AUIGrid.updateRow(myGridID, item, selectedItem[0]);
        }

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
                //alert("실패하였습니다.");
                alert('Failed to load data.');
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

    	 if(validate('i')){

    		 // Added to set plant & slplant attribute back to available before save.
    		 $("#iplant").attr("disabled"   , false);
             $("#islplant").attr("disabled" , false);

    		 console.log($("#insForm").serialize());
             //$('#instockgrade').attr("disabled",false)
               Common.ajax("GET", "/logistics/organization/insLocation.do", $("#insForm").serialize(), function(result) {
                Common.alert(""+result.message+"</br> Created WHID: "+result.data);
                //Common.alert(result.message);
                $( "#registWindow" ).hide();
                $('#insForm')[0].reset();

                }, function(jqXHR, textStatus, errorThrown) {
                    //Common.alert("실패하였습니다.");
                    Common.alert('Failed to insert record.');

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

    	 var slplant = (take == "i" ) ? $("#inwarecd").val() : $("#mwarecd").val() ;
    	 var rdcSlPlant = ($("#"+take+"rdccode").val() != null) ? $("#"+take+"rdccode").val() : $("#mrdccode").val();

    	 // Added for resetting plant value when location type onchange. By Hui Ding, 17/9/2019
    	 $("#"+take+"plant").val('');
    	 $("#"+take+"slplant").val('');

    	 if($("#"+id).val() == '03'){
    		 $("#"+take+"plant").val('6000');
    		 $("#"+take+"plant").attr("disabled"   , true);
    		 $("#"+take+"slplant").attr("disabled" , true);

    		 // Added for auto populating slPlant value when location type onchange. By Hui Ding, 17/9/2019
    		 $("#"+take+"slplant").val(rdcSlPlant);

         }else if($("#"+id).val() == '04'){
             $("#"+take+"plant").val('5000');
             $("#"+take+"plant").attr("disabled"   , true);
             $("#"+take+"slplant").attr("disabled" , true);

             // Added for auto populating slPlant value when location type onchange. By Hui Ding, 17/9/2019
             $("#"+take+"slplant").val(rdcSlPlant);
         }else if($("#"+id).val() == '09'){ // KR-OHK DT add
	         $("#"+take+"plant").val('8000');
	         $("#"+take+"plant").attr("disabled"   , true);
	         $("#"+take+"slplant").attr("disabled" , true);

	         // Added for auto populating slPlant value when location type onchange. By Hui Ding, 17/9/2019
	         $("#"+take+"slplant").val(rdcSlPlant);
	     }else{
        	 $("#"+take+"plant").attr("disabled"   , false);
        	 if ($("#"+id).val() == '02'){
        		 $("#"+take+"slplant").attr("disabled" , true);
        		 $("#"+take+"slplant").val(slplant);
        	 }else{
        		 $("#"+take+"slplant").attr("disabled" , false);
        	 }
         }

    	 /*default set serial check for CT,CODY,LT for new records*/
    	 if(id == "ilocationtype") {
    		var whLocCode =$("#"+id).val();

    		if(whLocCode == "03" || whLocCode == "04" || whLocCode == "09"){
				$("input[name=iserialRequireChkYn][value=Y]").prop("checked", true);
				$("#ipdchk").prop('checked', true);
				$("#iftchk").prop('checked', true);
				$("#iptchk").prop('checked', true);
    		}
    		else{
				$("input[name=iserialRequireChkYn][value=N]").prop("checked", true);
				$("#ipdchk").prop('checked', false);
				$("#iftchk").prop('checked', false);
				$("#iptchk").prop('checked', false);
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

    /* function f_validatation(){
	    if ($("#plant").val() == null || $("#plant").val() == undefined || $("#plant").val() == ""){
	        Common.alert("Please enter Plant in ECC.");
	        return false;
	    }
        return true;
    } */


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
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    </c:if>
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
    <th scope="row">Location Code</th>
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
    <th scope="row">Location Name</th>
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
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
    <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <%-- <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li> --%>
<%--     <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
    </c:if>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" class="autoGridHeight"></div>
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
    <td><select id="mstatus" name ="mstatus" class="w100p"></select></td>

    <th scope="row">Location Lane</th>
    <td><select id="loclane" class="w100p">
                <option value="">Choose One</option>
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
           </select>
     </td>
</tr>
<tr>
    <th scope="row">Location Code<span class="must">*</span></th>
    <td><input type="text" name="mwarecd" id="mwarecd"  class="w100p"/></td>
    <th scope="row">Serial Check</th>
    <td>
        <label><input type="checkbox" id="pdchk" name="pdchk"/><span>Stock</span></label>
        <label><input type="checkbox" id="ftchk" name="ftchk"/><span>Filter</span></label>
        <label><input type="checkbox" id="ptchk" name="ptchk"/><span>Spare Part</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Location Name<span class="must">*</span></th>
    <td><input type="text" name="mwarenm" id="mwarenm" class="w100p"/></td>
    <th scope="row">Serial Required Check Y/N<span class="must">*</span></th>
    <td>
        <label><input type="radio" id="serialRequireChkYn" name="serialRequireChkYn" value="Y"/><span>Y</span></label>
        <label><input type="radio" id="serialRequireChkYn" name="serialRequireChkYn" value="N"/><span>N</span></label>
    </td>
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
    <th scope="row">Location Grade<span class="must">*</span></th>
    <td><select id="mstockgrade" class="w100p"></select></td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td colspan='3'><select id="mwarebranch1" style="width: 273px!important"  ></select><select id="mwarebranch2" style="width: 273px!important" class="ml5"></select><select id="mwarebranch3" style="width: 273px!important"></select>
    <select id="mwarebranch4" style="width: 273px!important"  ></select><select id="mwarebranch5" style="width: 273px!important"  ></select>
    </td>
</tr>
<tr>
    <th scope="row">Contact No (1)<span class="must">*</span></th>
    <td><input type="text" name="mcontact1" id="mcontact1"  class="w100p"/></td>
    <th scope="row">Contact No (2)</th>
    <td><input type="text" name="mcontact2" id="mcontact2"  class="w100p"/></td>
</tr>
<tr>
    <th scope="row">Plant in ECC<span class="must">*</span></th>
    <td >
        <input type="text" title="" id="plant" name="plant" placeholder="" class="w100p" />
    </td>
    <th scope="row">S/L in ECC</th>
    <td >
        <input type="text" title="" id="slplant" name="slplant" placeholder="" class="w100p" />
    </td>
</tr>

<!-- Added for Flagging CDC to be used in Homecare or Home Appliance platform. By Hui Ding, 2020-08-07 -->
<tr>
    <th scope="row">Business Type</th>
    <td >
        <label><input type="checkbox" id="hcChk" name="hcChk"/><span>Home Care</span></label>
        <label><input type="checkbox" id="haChk" name="haChk"/><span>Home Appliance </span></label>
    </td>
    <th scope="row">&nbsp;</th>
    <td></td>
</tr>
<!-- End of amendment Flagging CDC to be used in Homecare or Home Appliance platform. By Hui Ding, 2020-08-07 -->

<tr>
    <th scope="row">CDC CODE</th>
    <td colspan='3'>
        <input type="text" id="rem" name="rem" class="w100p" maxlength="2" />
    </td>
</tr>
<tr>
    <th scope="row">Street search</th>

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
   <th scope="row">Area(4)</span></th>
	<td>
	<select class="w100p" id="mArea"  name="mArea" onchange="javascript : fn_getAreaId('m')"></select>
	</td>
	 <th scope="row">Street</th>
    <td><input type="text" title="" id="street" name="street" placeholder="Detail Address" class="w100p"  /></td>
</tr>
<tr>
	 <th scope="row">City(2)</th>
	<td>
	<select class="w100p" id="mCity"  name="mCity" onchange="javascript : fn_selectCity(this.value , 'm')"></select>
	</td>
	<th scope="row">PostCode(3)</th>
	<td>
	<select class="w100p" id="mPostCd"  name="mPostCd" onchange="javascript : fn_selectPostCode(this.value , 'm')"></select>
	</td>
</tr>
<tr>
	<th scope="row">State(1)</th>
	<td>
	<select class="w100p" id="mState"  name="mState" onchange="javascript : fn_selectState(this.value , 'm')"></select>
	</td>
	<th scope="row">Country</th>
	<td>
	<input type="text" title="" id="mCountry" name="mCountry" placeholder="" class="w100p readonly" readonly="readonly" value="Malaysia"/>
	</td>
</tr>

<br/><br/>
<tr>
    <th scope="row">Doc. No.</th>
    <td><input type="text" name="docNo" id="docNo" class="w100p readonly"  placeholder="Report For Decision Doc. No." readonly/></td>
    <th scope="row"></th>
    <td></td>
</tr>

</tbody>
</table><!-- table end -->
<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_updateGridRow();">SAVE</a></p></li>
    </c:if>
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
    <th scope="row">Location Code<span class="must">*</span></th>
    <td colspan="3"><input type="text" name="inwarecd" id="inwarecd" maxlength="10" class="w100p" /></td>
</tr>
<tr>
    <th scope="row">Location Name<span class="must">*</span></th>
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
    <th scope="row">Location Grade<span class="must">*</span></th>
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
        <select id="inwarebranch1" name="inwarebranch1" style="width: 273px!important" ></select> <select id="inwarebranch2" name="inwarebranch2"  style="width: 273px!important" class="ml5"></select> <select id="inwarebranch3" name="inwarebranch3" style="width: 273px!important"></select>
        <select id="inwarebranch4" name="inwarebranch4" style="width: 273px!important"></select> <select id="inwarebranch5" name="inwarebranch5" style="width: 273px!important"></select>
    </td>
</tr>
<tr>
    <th scope="row">Serial Check</th>
    <td>
        <label><input type="checkbox" id="ipdchk" name="ipdchk"/><span>Stock</span></label>
        <label><input type="checkbox" id="iftchk" name="iftchk"/><span>Filter</span></label>
        <label><input type="checkbox" id="iptchk" name="iptchk"/><span>Spare Part</span></label>
    </td>
    <th scope="row">Serial Required Check Y/N<span class="must">*</span></th>
    <td>
        <label><input type="radio" id="iserialRequireChkYn" name="iserialRequireChkYn" value="Y"/><span>Y</span></label>
        <label><input type="radio" id="iserialRequireChkYn" name="iserialRequireChkYn" value="N" checked/><span>N</span></label>
    </td>
</tr>

<!-- Added for Flagging CDC to be used in Homecare or Home Appliance platform. By Hui Ding, 2020-08-07 -->
<tr>
    <th scope="row">Business Type</th>
    <td >
        <label><input type="checkbox" id="ihcChk" name="ihcChk"/><span>Home Care</span></label>
        <label><input type="checkbox" id="ihaChk" name="ihaChk"/><span>Home Appliance </span></label>
    </td>
    <th scope="row">&nbsp;</th>
    <td></td>
</tr>
<!-- End of amendment Flagging CDC to be used in Homecare or Home Appliance platform. By Hui Ding, 2020-08-07 -->

<tr>
    <th scope="row">CDC CODE</th>
    <td colspan='3'>
        <input type="text" id="irem" name="irem" class="w100p" maxlength="2"/>
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
    <th scope="row">Contact No (1)<span class="must">*</span></th>
    <td><input type="text" name="incontact1" id="incontact1" class="w100p" /></td>
    <th scope="row">Contact No (2)</th>
    <td><input type="text" name="incontact2" id="incontact2" class="w100p" /></td>
</tr>
<br/><br/>
<tr>
    <th scope="row">Doc. No.<span class="must" display="none">*</span></th>
    <td><input type="text" name="inDocNo" id="inDocNo" class="w100p"  placeholder="Report For Decision Doc. No."/></td>
    <th scope="row"></th>
    <td></td>
</tr>

</tbody>
</table>


<ul class="center_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_insertGrid();">SAVE</a></p></li>
    </c:if>
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
                	 Common.alert("Invalid Area.");
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
