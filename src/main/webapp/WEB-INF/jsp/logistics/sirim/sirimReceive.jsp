<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<!-- <style type="text/css">

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


</style> -->
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">
var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "44","codeName": "Pending"},{"codeId": "36","codeName": "Closed"}];
var ReceiveStatusCombo = [{"codeId": "4","codeName": "Complete"},{"codeId": "50","codeName": "Incomplete"}];

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var detailGridID;
    var PendingGridID ;
    var CompleteGridID ;
    var IncompleteGridID;
    var receiveInfoGridID;
    var div;
    var trnsitId;
    var TransitStatusID;
    

    // AUIGrid 칼럼 설정                                                                            visible : false
 var columnLayout = [{dataField:    "trnsitNo",headerText :"<spring:message code='log.head.transitno'/>"               ,width:  "15%"     ,height:30 , visible:true},               
								{dataField: "trnsitDt",headerText :"<spring:message code='log.head.transitdate'/>"             ,width:  "15%"    ,height:30 , visible:true},                
								{dataField: "trnsitFrom",headerText :"<spring:message code='log.head.from'/>"       ,width: "13%"    ,height:30 , visible:true},                
								{dataField: "trnsitTo",headerText :"<spring:message code='log.head.to'/>"       ,width: "9%"     ,height:30 , visible:true},                
								{dataField: "trnsitStusCode",headerText :"<spring:message code='log.head.status'/>"     ,width: "13%"    ,height:30 , visible:true},                
								{dataField: "trnsitCrtUserIdUserName",headerText :"<spring:message code='log.head.createby'/>"      ,width: "15%"    ,height:30 , visible:true},                
								{dataField: "totTrnsitItm",headerText :"<spring:message code='log.head.totaltransfer'/>"        ,width: "20%"    ,height:30 , visible:true},                    
								{dataField: "trnsitCurier",headerText :"<spring:message code='log.head.trnsit_curier'/>"        ,width: "9%"     ,height:30 , visible:false},               
								{dataField: "trnsitStusId",headerText :"<spring:message code='log.head.trnsit_stus_id'/>"       ,width: "13%"    ,height:30 , visible:false},               
								{dataField: "trnsitStusName",headerText :"<spring:message code='log.head.trnsit_stus_name'/>"       ,width: "15%"    ,height:30 , visible:false},               
								{dataField: "trnsitCrtUserIdId",headerText :"<spring:message code='log.head.ttrnsit_crt_user_id_id'/>"      ,width: "20%"    ,height:30 , visible:false},               
								{dataField: "trnsitClosDt",headerText :"<spring:message code='log.head.trnsit_clos_dt'/>"       ,width: "9%"     ,height:30 , visible:false},               
								{dataField: "trnsitStusId",headerText :"<spring:message code='log.head.trnsit_stus_id'/>"       ,width: "13%"    ,height:30 , visible:false},               
								{dataField: "totCnt",headerText :"<spring:message code='log.head.tot_cnt'/>"        ,width: "15%"    ,height:30 , visible:false},               
								{dataField: "trnsitId",headerText :"<spring:message code='log.head.trnsit_id'/>"        ,width: "15%"    ,height:30 , visible:false} 
                       ];
    
 var detailLayout = [{dataField: "codeDesc",headerText :"<spring:message code='log.head.type'/>"            ,width:  "15%"     ,height:30 ,  visible:true},                  
                     {dataField: "srmNo",headerText :"<spring:message code='log.head.sirimno'/>"            ,width:  "15%"    ,height:30 , visible:true},                
                     {dataField: "code",headerText :"<spring:message code='log.head.status'/>"       ,width: "15%"    ,height:30 , visible:true},                
                     {dataField: "trTransClosDt",headerText :"<spring:message code='log.head.closedate'/>"       ,width: "20%"    ,height:30 , visible:true},                
                     {dataField: "userName",headerText :"<spring:message code='log.head.updateby'/>"     ,width: "15%"    ,height:30 , visible:true},                
                     {dataField: "srmTransUpdDt",headerText :"<spring:message code='log.head.updatedate'/>"      ,width: "20%"    ,height:30 , visible:true},                                    
                     /*    {dataField:   "trnsitTo   ,headerText:    ""      ,width: "9%"     ,height:30 , visible:true},                
                     {dataField: "trnsitStusCode",headerText :"<spring:message code='log.head.status'/>"     ,width: "13%"    ,height:30 , visible:true},                
                     {dataField: "trnsitCrtUserIdUserName",headerText :"<spring:message code='log.head.createby'/>"      ,width: "15%"    ,height:30 , visible:true}, */     
                       ];
    
    
 var receiveInfoLayout = [{dataField:    "trnsitId",headerText :"<spring:message code='log.head.trnsit_id'/>"               ,width:  "15%"     ,height:30 , visible:false},                  
                          {dataField: "trnsitNo",headerText :"<spring:message code='log.head.trnsit_no'/>"               ,width:  "15%"    ,height:30 , visible:false},               
                          {dataField: "trnsitDt",headerText :"<spring:message code='log.head.trnsit_dt'/>"        ,width: "15%"    ,height:30 , visible:false},               
                          {dataField: "trnsitFrom",headerText :"<spring:message code='log.head.trnsit_from'/>"        ,width: "20%"    ,height:30 , visible:false},               
                          {dataField: "trnsitTo",headerText :"<spring:message code='log.head.trnsit_to'/>"        ,width: "15%"    ,height:30 , visible:false},               
                          {dataField: "trnsitCurier",headerText :"<spring:message code='log.head.trnsit_curier'/>"        ,width: "20%"    ,height:30 , visible:false},                                       
                          {dataField: "trnsitStusId",headerText :"<spring:message code='log.head.trnsit_stus_id'/>"       ,width: "9%"     ,height:30 , visible:false},               
                          {dataField: "trnsitStusCode",headerText :"<spring:message code='log.head.trnsit_stus_code'/>"       ,width: "13%"    ,height:30 , visible:false},               
                          {dataField: "trnsitStusName",headerText :"<spring:message code='log.head.trnsit_stus_name'/>"       ,width: "15%"    ,height:30 , visible:false},               
                          {dataField: "trnsitCrtUserIdId",headerText :"<spring:message code='log.head.trnsit_crt_user_id_id'/>"       ,width: "15%"    ,height:30 , visible:false},               
                          {dataField: "trnsitCrtUserIdUserName"    ,headerText:    ""      ,width: "15%"    ,height:30 , visible:false},               
                          {dataField: "trnsitClosDt",headerText :"<spring:message code='log.head.trnsit_clos_dt'/>"       ,width: "15%"    ,height:30 , visible:false},               
                          {dataField: "totTrnsitItm",headerText :"<spring:message code='log.head.tot_trnsit_itm'/>"       ,width: "15%"    ,height:30 , visible:false},               
                          {dataField: "totCnt",headerText :"<spring:message code='log.head.tot_cnt'/>"        ,width: "15%"    ,height:30 , visible:false}
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
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    
    var subgridpros = {
            // 페이지 설정
            usePaging : true,                
            pageRowCount : 10,                
            editable : false,                
            noDataMessage : "출력할 데이터가 없습니다.",
            enableSorting : true,
            selectionMode : "multipleRows",
            //selectionMode : "multipleCells",
            useGroupingPanel : true,
            // 체크박스 표시 설정
            showRowCheckColumn : true,
            // 전체 체크박스 표시 설정
            showRowAllCheckBox : true,
            softRemoveRowMode:false
            };
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        doDefCombo(comboData, '' ,'searchTransitStatus', 'S', ''); //Transit Status 리스트 조회
        doGetCombos('/logistics/sirim/receiveWarehouseList.do', '', '','searchWarehouse', 'S' , ''); //Receive Warehouse 리스트 조회
        
        
        $("#popup_wrap").hide();
        //Common.popupDiv("/sales/customer/selectCustomerView.do", $("#popForm").serializeJSON());
        
        
        
        AUIGrid.bind(myGridID, "cellClick", function( event )  
        {
            
            
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {   
        	destory(detailGridID);
        	div="showAll";
        	  $("#ShowAll_info").trigger("click");
        	   var selectedItem = AUIGrid.getSelectedIndex(myGridID);
               if (selectedItem[0] > -1){
            	   fn_sirimReceiveDetail(selectedItem[0]);
            	    trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
                     getSirimReceiveListAjax(trnsitId,div); 
                   $("#ViewPopUp_wrap").show();  
                   detailGridID = GridCommon.createAUIGrid("detailGrid_wrap", detailLayout,"", gridoptions);      
               }else{
               Common.alert('Choice Data please..');
               }
        	
        	
        });
       
        /* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
        /* 팝업 드래그 end */
        });
    
    
    $(function(){
        $("#search").click(function(){
        	getReceiveSirimListAjax();	
         });   
        
        $("#clear").click(function(){
            $("#SearchForm")[0].reset();
        });
        
        $("#receive").click(function(){
        	destory(PendingGridID);
          div="Pending";
         var selectedItem = AUIGrid.getSelectedIndex(myGridID);
         if (selectedItem[0] > -1){ 
         var  trnsitStusId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitStusId');
         var  trnsitStusCode = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitStusCode');
         trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
         if(trnsitStusCode == "ACT" || trnsitStusCode == "PEN" || trnsitStusCode == "CLO"){
        	 SirimReceiveInfoAjax(trnsitId);
        	 receiveInfoGridID = GridCommon.createAUIGrid("detailGrid_wrap", receiveInfoLayout,"", subgridpros); 
        	 fn_sirimReceiveInfo(selectedItem[0]);
        	 $("#ReceivePopUp_wrap").show();
        	  //pageLoad(trnsitStusId);
        	 doDefCombo(ReceiveStatusCombo, '' ,'receiveStatus', 'S', ''); //Transit Status 리스트 조회
        	 $('input:radio[value=S]').is(':checked');
             getSirimReceiveListAjax(trnsitId,div); 
             TransitStatusID="44";
             $("#ResultStusId").val(TransitStatusID);
             PendingGridID = GridCommon.createAUIGrid("ReceivePendingGrid_wrap", detailLayout,"", subgridpros);  	 
         }else{
        	 Common.alert("Only active/pending sirim transit can do receive result.");
         }
         }else{
         Common.alert('Choice Data please..');
         }
              
           }); 
        
        $("#Pending_info").click(function(){
        	destory(PendingGridID);
            div="Pending";
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
        	PendingGridID = GridCommon.createAUIGrid("PendingGrid_wrap", detailLayout,"", gridoptions);  	
        });
        $("#Complete_info").click(function(){
        	destory(CompleteGridID);
        	div="Complete";
        	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        	trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
        	CompleteGridID = GridCommon.createAUIGrid("CompleteGrid_wrap", detailLayout,"", gridoptions);     	
        });
        $("#Incomplete_info").click(function(){    
        	destory(IncompleteGridID);
        	div="Incomplete";
        	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        	trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
        	IncompleteGridID = GridCommon.createAUIGrid("IncompleteGrid_wrap", detailLayout,"", gridoptions);
        	AUIGrid.resize(IncompleteGridID); 
        });

        
        $("#ReceivePending_info").click(function(){
            destory(PendingGridID);
            div="Pending";
            TransitStatusID="44";
            $("#ResultStusId").val(TransitStatusID);
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
            PendingGridID = GridCommon.createAUIGrid("ReceivePendingGrid_wrap", detailLayout,"", subgridpros);     
        });
        $("#ReceiveComplete_info").click(function(){
            destory(CompleteGridID);
            div="Complete";
            TransitStatusID="4";
            $("#ResultStusId").val(TransitStatusID);
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
            CompleteGridID = GridCommon.createAUIGrid("ReceiveCompleteGrid_wrap", detailLayout,"", gridoptions);       
        });
        $("#ReceiveIncomplete_info").click(function(){    
            destory(IncompleteGridID);
            div="Incomplete";
            TransitStatusID="50";
            $("#ResultStusId").val(TransitStatusID);
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
            IncompleteGridID = GridCommon.createAUIGrid("ReceiveIncompleteGrid_wrap", detailLayout,"", gridoptions);
            AUIGrid.resize(IncompleteGridID); 
        });
        
        $("input:radio[name=receiveRadio]").click(function(){
        var radioValue =	$("input:radio[name=receiveRadio]:checked").val();
            if(radioValue == "A" ){
            	//setAllCheckedRows();
            	setCheckedRowsByValue();
            }else{
            	var allChecked = false;
                AUIGrid.setAllCheckedRows(PendingGridID, allChecked);
            } 	    
       }) 
   
          
    });
    
    
    function getReceiveSirimListAjax() {  
        Common.ajax("POST", "/logistics/sirim/selectReceiveList.do",  $('#SearchForm').serializeJSON(), function(result) {
          var gridData = result;             
                      
          AUIGrid.setGridData(myGridID, gridData.data); 
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
}    
    
    function getSirimReceiveListAjax(trnsitId,div) { 
     	var param;
     	
    	  if(div=="showAll"){
    		  param={"trnsitId" :trnsitId };
          }else if(div=="Pending"){
              param= {"trnsitId" :trnsitId ,"srmResultStusId" :44};
          }else if(div=="Complete"){
              param= {"trnsitId" :trnsitId ,"srmResultStusId" :4};
          }else if(div=="Incomplete"){
              param = {"trnsitId" :trnsitId ,"srmResultStusId" :50};
          } 
        Common.ajax("POST", "/logistics/sirim/detailReceiveList.do", param, function(result) {
          var gridData = result;             
             
          if(div=="showAll"){
        	  AUIGrid.setGridData(detailGridID, gridData.data);
        	  
          }else if(div=="Pending"){
        	  AUIGrid.setGridData(PendingGridID, gridData.data);
        	  AUIGrid.resize(PendingGridID);
          }else if(div=="Complete"){
        	  AUIGrid.setGridData(CompleteGridID, gridData.data);
        	  AUIGrid.resize(CompleteGridID);
          }else if(div=="Incomplete"){
        	  AUIGrid.setGridData(IncompleteGridID, gridData.data);
        	  AUIGrid.resize(IncompleteGridID);
          } 
 
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
}  
    
    function SirimReceiveInfoAjax(trnsitId) {  
        Common.ajax("POST", "/logistics/sirim/getSirimReceiveInfo.do",{"trnsitId" :trnsitId } , function(result) {
          var gridData = result;             
                      
            AUIGrid.setGridData(receiveInfoGridID, gridData.data);
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
}    
    function InsertReceiveInfoAjax(TransitStatusID) {
    	var param;
    	var SelectedItems;
    	var checkedItems;
         if(TransitStatusID == "44" ){
          checkedItems = AUIGrid.getCheckedRowItemsAll(PendingGridID);   
	    }else if(TransitStatusID == "4"){
	      checkedItems = AUIGrid.getCheckedRowItemsAll(PendingGridID);
	    }else if(TransitStatusID == "50"){
	       checkedItems = AUIGrid.getCheckedRowItemsAll(PendingGridID);
	    } 

        
        if(checkedItems.length <= 0) {
            return false;
        }else{
            var data = {};
            data.checked = checkedItems; 
            data.form = $("#InsertReceiveForm").serializeJSON();
         
    	
    	/* if(TransitStatusID == "44" ){
    		SelectedItems =  AUIGrid.getSelectedItems(PendingGridID);	
    	}else if(TransitStatusID == "4"){
    	    SelectedItems =  AUIGrid.getSelectedItems(CompleteGridID);   	
    	}else if(TransitStatusID == "50"){
    		SelectedItems =  AUIGrid.getSelectedItems(IncompleteGridID);
    	} */
    	
    	/* var data = {};
    	data.select = SelectedItems;
        data.form = $("#InsertReceiveForm").serializeJSON(); */
       
    Common.ajax("POST", "/logistics/sirim/InsertReceiveInfo.do",data , function(result) {
          var gridData = result;             
                
        if(TransitStatusID == "44" ){
        	 $("#ReceivePending_info").click(); 
        }else if(TransitStatusID == "4"){
        	 $("#ReceiveComplete_info").click();      
        }else if(TransitStatusID == "50"){
        	 $("#ReceiveIncomplete_info").click();
        }  
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
         }); 
        }
}  
    
    
    function fn_sirimReceiveDetail(rowid){
    	
        $("#viewTransitNo").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitNo'));
        $("#viewTransitDate").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitDt'));
        $("#viewTransitStatus").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitStusName'));      
        $("#viewTransitBy").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitCrtUserIdUserName'));  
        $("#viewTransitCloseDate").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitClosDt'));     
        $("#viewTotalSirimTransit").val(AUIGrid.getCellValue(myGridID ,rowid,'totTrnsitItm'));
        $("#viewTransitLocation").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitFrom') +" To "+ AUIGrid.getCellValue(myGridID ,rowid,'trnsitTo'));
        $("#viewTransitCourier").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitCurier'));
       
        //$("#masterWindow").show();
    }
         
   function fn_sirimReceiveInfo(rowid){
        $("#receiveInfoTransitNo").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitNo'));
        $("#receiveInfoTransitDate").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitDt'));
        $("#receiveInfoTransitStatus").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitStusName'));      
        $("#receiveInfoTransitBy").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitCrtUserIdUserName'));  
        $("#receiveInfoTransitLocation").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitFrom') +" To "+ AUIGrid.getCellValue(myGridID ,rowid,'trnsitTo'));     
        $("#receiveInfoCourier").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitCurier'));
        $("#receiveInfoTotalSirimTransit").val(AUIGrid.getCellValue(myGridID ,rowid,'totTrnsitItm'));
        $("#SirimLocTo").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitTo'));
        $("#SirimLocFrom").val(AUIGrid.getCellValue(myGridID ,rowid,'trnsitFrom'));
       
        //$("#masterWindow").show();
    }
    
   function fn_insertReceiveInfo(){
	  
	 var  TransitStatusID = $("#ResultStusId").val();  
	 var ReceiveOption = $('input:radio[name="receiveRadio"]:checked').val();

	  if(ReceiveOption == "S"){
	   if(TransitStatusID == "44"){
		  if(valiedcheck()){
	      InsertReceiveInfoAjax(TransitStatusID);		   
		  }
	   }else{
		   alert("You must select item in the pending list.");
	   }
	  }else{
		  if(valiedcheck()){
	          InsertReceiveInfoAjax(TransitStatusID);          
		  }
	  }
    
}
   
  
//Warehouse 셀렉트박스 CODE+CODENAME    
  function doGetCombos(url, groupCd , selCode, obj , type, callbackFn){
      
      $.ajax({
          type : "GET",
          url : getContextPath() + url,
          data : { groupCode : groupCd},
          dataType : "json",
          contentType : "application/json;charset=UTF-8",
          success : function(data) {
             var rData = data;
             doDefCombos(rData, selCode, obj , type,  callbackFn);
          },
          error: function(jqXHR, textStatus, errorThrown){
              alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
          },
          complete: function(){
          }
      }); 
  } ;    
  
  
  function doDefCombos(data, selCode, obj , type, callbackFn){
      var targetObj = document.getElementById(obj);
      var custom = "";
      
      for(var i=targetObj.length-1; i>=0; i--) {
          targetObj.remove( i );
      }
      obj= '#'+obj;
      if (type&&type!="M") {
          custom = (type == "S") ? eTrusttext.option.choose : ((type == "A") ? eTrusttext.option.all : "");               
          $("<option />", {value: "", text: custom}).appendTo(obj);
      }else{
          $(obj).attr("multiple","multiple");
      }
      
      $.each(data, function(index,value) {
          //CODEID , CODE , CODENAME ,,description
              if(selCode==data[index].codeId){
                  $('<option />', {value : data[index].code, text:data[index].code+"-"+data[index].codeName}).appendTo(obj).attr("selected", "true");
              }else{
                  $('<option />', {value : data[index].code, text:data[index].code+"-"+data[index].codeName}).appendTo(obj);
              }
          });    
		                        
		        
        if(callbackFn){
            var strCallback = callbackFn+"()";
            eval(strCallback);
        }
    };     
    
//     function f_reWarehouseCombo() {
//         $(function() {
//               $("#searchWarehouse").val("CDB-HQ").prop("selected", true);
              
   
//           });       
//     }
    
    function destory(gridNm) {
        AUIGrid.destroy(gridNm);
    }
    
    function valiedcheck() {   
    	  
        if ($("#receiveStatus").val() == "") {
            Common.alert("* Please select the Receive Status.");
            $("#receiveStatus").focus();
            return false;
        }

        var checkedItems = AUIGrid.getCheckedRowItems(PendingGridID);
        if(checkedItems.length <= 0) {
            Common.alert('Pending Have No Data');
            return false;
        }    
        
        
        return true;
    }
    
    
    function pageLoad(trnsitStusId) {
    	if(trnsitStusId !="1"){	
    	$("#receiveStatus").prop('disabled',true);	
    	$("#receiveRadio").prop('disabled',true); //radio 비활성화
    	$("#saveBtn").unbind("click"); //a태그 비활성화
    	}
       
    }
    
    function setAllCheckedRows() {
    	var allChecked = false;
        allChecked = !allChecked;
        AUIGrid.setAllCheckedRows(PendingGridID, allChecked);
    };
  
    function setCheckedRowsByValue() {
        
        // rowIdField 와 상관없이 행 아이템의 특정 값에 체크함
        // 행아이템의 name 필드 중 Anna 라는 사람을 모두 체크함
        AUIGrid.setCheckedRowsByValue(PendingGridID, "code", "PEN");
        
        // 만약 복수 값(Anna, Steve) 체크 하고자 한다면 다음과 같이 배열로 삽입
        //AUIGrid.setCheckedRowsByValue(myGridID, "name", ["Anna", "Steve"]);
    };
    function addUncheckedRowsByValue() {
        // 행아이템의 name 필드 중 Emma 라는 사람을 모두 체크 해제함
        AUIGrid.addUncheckedRowsByValue(PendingGridID, "code", "PEN");
    };
    
    

</script>
</head>
<body>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sirim Management</li>
    <li>Sirim Receive</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Sirim Receive</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="SearchForm" name="SearchForm"   method="post">

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
    <th scope="row">Transit No</th>
    <td>
    <input type="text" id="searchTransitNo" name="searchTransitNo" title="" placeholder="Transit No" class="w100p" />
    </td>
    <th scope="row">Transit Status</th>
    <td>
    <select id="searchTransitStatus" name="searchTransitStatus" class="w100p" >
    </select>
    </td>
    <th scope="row">Receive Warehouse</th>
    <td>
    <select id="searchWarehouse" name="searchWarehouse" class="w100p">
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<!--     <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li> -->
<%--     <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.ins' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="receive">Receive</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap"></div>

</article><!-- grid_wrap end -->

</section><!-- search_result end -->



<div id="ViewPopUp_wrap" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Transfer / Receive Details View</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Sirim Transit Details</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Transit No</th>
    <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="viewTransitNo" name="viewTransitNo"/></td>
    <th scope="row">Transit Date</th>
    <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="viewTransitDate" name="viewTransitDate"/></td>
</tr>
<tr>
    <th scope="row">Transit Status</th>
    <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="viewTransitStatus" name="viewTransitStatus"/></td>
    <th scope="row">Transit By</th>
   <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="viewTransitBy" name="viewTransit By"/></td>
</tr>
<tr>
    <th scope="row">Transit Close Date</th>
   <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="viewTransitCloseDate" name="viewTransitCloseDate"/></td>
    <th scope="row">Total Sirim Transit</th>
    <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="viewTotalSirimTransit" name="viewTotalSirimTransit"/></td>
</tr>
<tr>
    <th scope="row">Transit Location</th>
    <td colspan="5" ><input type="text" title="" placeholder=""  class="w100p" id="viewTransitLocation" name="viewTransitLocation"/></td>
</tr>
<tr>
    <th scope="row">Transit Courier</th>
    <td colspan="5" ><input type="text" title="" placeholder=""  class="w100p" id="viewTransitCourier" name="viewTransitCourier"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Sirim To Transit</h2>
</aside><!-- title_line end -->

<section class="tap_wrap mt0"><!-- tap_wrap start -->
<ul class="tap_type1">  
    <li id="ShowAll_info" class="on"><a href="#">Show All </a></li>
    <li id="Pending_info"><a href="#"> Only Pending </a></li>
    <li id="Complete_info"><a href="#"> Only Complete </a></li>
    <li id="Incomplete_info"><a href="#"> Only Incomplete </a></li>   
</ul>

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap" ><!-- grid_wrap start -->
<div id="detailGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="PendingGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="CompleteGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="IncompleteGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->








<div id="ReceivePopUp_wrap" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Sirim Receive</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->

<aside class="title_line"><!-- title_line start -->
<h2>Sirim Transit Information</h2>
</aside><!-- title_line end -->

<form id="InsertReceiveForm" name="InsertReceiveForm"   method="post">
<input type="hidden" id="SirimLocTo" name="SirimLocTo"/>
<input type="hidden" id="SirimLocFrom" name="SirimLocFrom"/>
<input type="hidden" id="ResultStusId" name="ResultStusId"/>
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Transit No</th>
    <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="receiveInfoTransitNo" name="receiveInfoTransitNo"/></td>
    <th scope="row">Transit Date</th>
    <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="receiveInfoTransitDate" name="receiveInfoTransitDate"/></td>
</tr>
<tr>
    <th scope="row">Transit Status</th>
    <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="receiveInfoTransitStatus" name="receiveInfoTransitStatus"/></td>
    <th scope="row">Transit By</th>
    <td colspan="2" ><input type="text" title="" placeholder=""  class="w100p" id="receiveInfoTransitBy" name="receiveInfoTransitBy"/></td>
</tr>
<tr>
    <th scope="row">Transit Location</th>
    <td colspan="5" ><input type="text" title="" placeholder=""  class="w100p" id="receiveInfoTransitLocation" name="receiveInfoTransitLocation"/></td>
</tr>
<tr>
    <th scope="row">Courier</th>
    <td colspan="5" ><input type="text" title="" placeholder=""  class="w100p" id="receiveInfoCourier" name="receiveInfoCourier"/></td>
</tr>
<tr>
    <th scope="row">Total Sirim Transit</th>
    <td colspan="5" ><input type="text" title="" placeholder=""  class="w100p" id="receiveInfoTotalSirimTransit" name="receiveInfoTotalSirimTransit"/></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="title_line"><!-- title_line start -->
<h2>Sirim To Receive</h2>
</aside><!-- title_line end -->

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Receive Option</th>
    <td>
    <label><input type="radio" id="receiveRadio" name="receiveRadio" value="S" checked /><span>Only selected item(s)</span></label>
    <label><input type="radio" id="receiveRadio" name="receiveRadio" value="A"  /><span>All item(s)</span></label>
    </td>
</tr>
<tr>
    <th scope="row">Receive Status</th>
    <td colspan="3">
   <select id="receiveStatus" name="receiveStatus" class="w100p" >
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->
</form>
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_insertReceiveInfo();" id= "saveBtn">SAVE</a></p></li>
</ul>

<section class="tap_wrap mt30"><!-- tap_wrap start -->
<ul class="tap_type1">
    <li id="ReceivePending_info"><a href="#" class="on"> Only Pending </a></li>
    <li id="ReceiveComplete_info"><a href="#"> Only Complete </a></li>
    <li id="ReceiveIncomplete_info"><a href="#"> Only Incomplete </a></li>   
    
</ul>

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ReceivePendingGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ReceiveCompleteGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ReceiveIncompleteGrid_wrap"></div>

</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->











</section><!-- content end -->

