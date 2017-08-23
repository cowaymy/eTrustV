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
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
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
    
    
        

    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"trnsitNo"      ,headerText:"Transit No"           ,width:"15%"  ,height:30 , visible:true},
                        {dataField:"trnsitDt"      ,headerText:"Transit Date"           ,width:"15%" ,height:30 , visible:true},
                        {dataField:"trnsitFrom"    ,headerText:"From"    ,width:"13%" ,height:30 , visible:true},
                        {dataField:"trnsitTo"    ,headerText:"To"    ,width:"9%" ,height:30 , visible:true},
                        {dataField:"trnsitStusCode"    ,headerText:"Status"    ,width:"13%" ,height:30 , visible:true},
                        {dataField:"trnsitCrtUserIdUserName"    ,headerText:"Create By"    ,width:"15%" ,height:30 , visible:true},
                        {dataField:"totTrnsitItm"    ,headerText:"Total Transfer"    ,width:"20%" ,height:30 , visible:true},  
                        {dataField:"trnsitCurier"    ,headerText:"TRNSIT_CURIER"    ,width:"9%" ,height:30 , visible:false},
                        {dataField:"trnsitStusId"    ,headerText:"TRNSIT_STUS_ID"    ,width:"13%" ,height:30 , visible:false},
                        {dataField:"trnsitStusName"    ,headerText:"TRNSIT_STUS_NAME"    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trnsitCrtUserIdId"    ,headerText:"TTRNSIT_CRT_USER_ID_ID"    ,width:"20%" ,height:30 , visible:false},
                        {dataField:"trnsitClosDt"    ,headerText:"TRNSIT_CLOS_DT"    ,width:"9%" ,height:30 , visible:false},
                        {dataField:"trnsitStusId"    ,headerText:"TRNSIT_STUS_ID"    ,width:"13%" ,height:30 , visible:false},
                        {dataField:"totCnt"    ,headerText:"TOT_CNT"    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trnsitId"    ,headerText:"TRNSIT_ID"    ,width:"15%" ,height:30 , visible:false},
                       ];
    
    var detailLayout = [{dataField:"codeDesc"      ,headerText:"Type"           ,width:"15%"  ,height:30 , visible:true},
                        {dataField:"srmNo"      ,headerText:"Sirim No"           ,width:"15%" ,height:30 , visible:true},
                        {dataField:"code"    ,headerText:"Status"    ,width:"15%" ,height:30 , visible:true},
                        {dataField:"trTransClosDt"    ,headerText:"Close Date"    ,width:"20%" ,height:30 , visible:true},
                        {dataField:"userName"    ,headerText:"Update By"    ,width:"15%" ,height:30 , visible:true},
                        {dataField:"srmTransUpdDt"    ,headerText:"Update Date"    ,width:"20%" ,height:30 , visible:true},                     
                     /*    {dataField:"trnsitTo"    ,headerText:"SRM_TRANS_ITM_ID  "    ,width:"9%" ,height:30 , visible:true},
                        {dataField:"trnsitStusCode"    ,headerText:"Status"    ,width:"13%" ,height:30 , visible:true},
                        {dataField:"trnsitCrtUserIdUserName"    ,headerText:"Create By"    ,width:"15%" ,height:30 , visible:true}, */
                       ];
    
    
    var receiveInfoLayout = [{dataField:"trnsitId"      ,headerText:"TRNSIT_ID"           ,width:"15%"  ,height:30 , visible:false},
                        {dataField:"trnsitNo"      ,headerText:"TRNSIT_NO"           ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trnsitDt"    ,headerText:"TRNSIT_DT"    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trnsitFrom"    ,headerText:"TRNSIT_FROM"    ,width:"20%" ,height:30 , visible:false},
                        {dataField:"trnsitTo"    ,headerText:"TRNSIT_TO"    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trnsitCurier"    ,headerText:"TRNSIT_CURIER"    ,width:"20%" ,height:30 , visible:false},                     
                        {dataField:"trnsitStusId"    ,headerText:"TRNSIT_STUS_ID"    ,width:"9%" ,height:30 , visible:false},
                        {dataField:"trnsitStusCode"    ,headerText:"TRNSIT_STUS_CODE"    ,width:"13%" ,height:30 , visible:false},
                        {dataField:"trnsitStusName"    ,headerText:"TRNSIT_STUS_NAME"    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trnsitCrtUserIdId"    ,headerText:"TRNSIT_CRT_USER_ID_ID"    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trnsitCrtUserIdUserName  "    ,headerText:"TRNSIT_CRT_USER_ID_USER_NAME  "    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"trnsitClosDt"    ,headerText:"TRNSIT_CLOS_DT"    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"totTrnsitItm"    ,headerText:"TOT_TRNSIT_ITM"    ,width:"15%" ,height:30 , visible:false},
                        {dataField:"totCnt"    ,headerText:"TOT_CNT"    ,width:"15%" ,height:30 , visible:false}, 
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
            editable : true,                
            noDataMessage : "출력할 데이터가 없습니다.",
            enableSorting : true,
            softRemoveRowMode:false
            };
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        doDefCombo(comboData, '' ,'searchTransitStatus', 'S', ''); //Transit Status 리스트 조회
        doGetCombos('/logistics/sirim/receiveWarehouseList.do', '42', '','searchWarehouse', 'S' , 'f_reWarehouseCombo'); //Receive Warehouse 리스트 조회
        
        
        $("#popup_wrap").hide();
        //Common.popupDiv("/sales/customer/selectCustomerView.do", $("#popForm").serializeJSON());
        
        
        
        AUIGrid.bind(myGridID, "cellClick", function( event )  
        {
            
            
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {   
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
            
        $("#receive").click(function(){
          div="Pending";
         var selectedItem = AUIGrid.getSelectedIndex(myGridID);
         if (selectedItem[0] > -1){
         var  trnsitStusCode = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitStusCode');
         trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
         if(trnsitStusCode == "ACT" || trnsitStusCode == "PEN" || trnsitStusCode == "CLO"){
        	 SirimReceiveInfoAjax(trnsitId);
        	 receiveInfoGridID = GridCommon.createAUIGrid("detailGrid_wrap", receiveInfoLayout,"", gridoptions); 
        	 fn_sirimReceiveInfo(selectedItem[0]);
        	 $("#ReceivePopUp_wrap").show();
        	 doDefCombo(ReceiveStatusCombo, '' ,'receiveStatus', 'S', ''); //Transit Status 리스트 조회
        	 $('input:radio[value=S]').is(':checked');
             getSirimReceiveListAjax(trnsitId,div); 
             PendingGridID = GridCommon.createAUIGrid("ReceivePendingGrid_wrap", detailLayout,"", gridoptions);  	 
         }else{
        	 Common.alert("Only active/pending sirim transit can do receive result.");
         }
         alert("trnsitStusCode :      "+trnsitStusCode);
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
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
            PendingGridID = GridCommon.createAUIGrid("ReceivePendingGrid_wrap", detailLayout,"", gridoptions);     
        });
        $("#ReceiveComplete_info").click(function(){
            destory(CompleteGridID);
            div="Complete";
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
            CompleteGridID = GridCommon.createAUIGrid("ReceiveCompleteGrid_wrap", detailLayout,"", gridoptions);       
        });
        $("#ReceiveIncomplete_info").click(function(){    
            destory(IncompleteGridID);
            div="Incomplete";
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            trnsitId = AUIGrid.getCellValue(myGridID ,selectedItem[0],'trnsitId');
            getSirimReceiveListAjax(trnsitId,div); 
            IncompleteGridID = GridCommon.createAUIGrid("ReceiveIncompleteGrid_wrap", detailLayout,"", gridoptions);
            AUIGrid.resize(IncompleteGridID); 
        });
        
        

      
          
    });
    
    
    function getReceiveSirimListAjax() {  
        Common.ajax("POST", "/logistics/sirim/selectReceiveList.do",  $('#SearchForm').serializeJSON(), function(result) {
          var gridData = result;             
          //console.log(gridData.data);            
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
          //console.log(gridData.data);   
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
          //console.log(gridData.data);            
            AUIGrid.setGridData(receiveInfoGridID, gridData.data);
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
}    
    function InsertReceiveInfoAjax() {
    	
    	//param = GridCommon.getEditData(PendingGridID);
    	param = AUIGrid.getSelectedItems(PendingGridID);
        //param.form = $("#InsertReceiveForm").serializeJSON();
    	
        Common.ajax("POST", "/logistics/sirim/InsertReceiveInfo.do",param , function(result) {
          var gridData = result;             
          //console.log(gridData.data);            
            
        // 공통 메세지 영역에 메세지 표시.
        Common.setMsg("<spring:message code='sys.msg.success'/>");
        //searchList();
        }, function(jqXHR, textStatus, errorThrown) {
            Common.alert("실패하였습니다.");
        });
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
       
        //$("#masterWindow").show();
    }
    
   function fn_insertReceiveInfo(){
   alert("인서트!!!!");
/*    var array =  AUIGrid.getSelectedItems(PendingGridID);
   alert(array); */
   
   
   var ReceiveOption = $("input[name='receiveRadio']").val();
   alert("라디오???:::::   "+ReceiveOption);
   InsertReceiveInfoAjax();
   
   
   
	    
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
    
    function f_reWarehouseCombo() {
        $(function() {
              $("#searchWarehouse").val("CDB-HQ").prop("selected", true);
              
   
          });       
    }
    
    function destory(gridNm) {
        AUIGrid.destroy(gridNm);
    }

    

</script>
</head>
<body>

<div id="wrap"><!-- wrap start -->
      
<section id="container"><!-- container start -->

<aside class="lnb_wrap"><!-- lnb_wrap start -->

<header class="lnb_header"><!-- lnb_header start -->
<form action="#" method="post">
<h1><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/logo.gif" alt="eTrust system" /></a></h1>
<p class="search">
<input type="text" title="검색어 입력" />
<input type="image" src="${pageContext.request.contextPath}/resources/images/common/icon_lnb_search.gif" alt="검색" />

</p>

</form>
</header><!-- lnb_header end -->

<section class="lnb_con"><!-- lnb_con start -->
<p class="click_add_on_solo on"><a href="#">All menu</a></p>
<ul class="inb_menu">
    <li class="active">
    <a href="#" class="on">menu 1depth</a>

    <ul>
        <li class="active">
        <a href="#" class="on">menu 2depth</a>

        <ul>
            <li class="active">
            <a href="#" class="on">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
            <li>
            <a href="#">menu 3depth</a>
            </li>
        </ul>

        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
        <li>
        <a href="#">menu 2depth</a>
        </li>
    </ul>

    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
    <li>
    <a href="#">menu 1depth</a>
    </li>
</ul>
<p class="click_add_on_solo"><a href="#"><span></span>My menu</a></p>
<ul class="inb_menu">
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
    <li>
    <a href="#">My menu 1depth</a>
    </li>
</ul>
</section><!-- lnb_con end -->

</aside><!-- lnb_wrap end -->

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
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
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

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
    <li><p class="btn_grid"><a href="#">EXCEL UP</a></p></li>
    <li><p class="btn_grid"><a href="#">EXCEL DW</a></p></li>
    <li><p class="btn_grid"><a href="#">DEL</a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.ins' /></a></p></li>
    <li><p class="btn_grid"><a id="receive">Receive</a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap"></div>
그리드영역
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
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="PendingGrid_wrap"></div>
그리드 영역2
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="CompleteGrid_wrap"></div>
그리드 영역3
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="IncompleteGrid_wrap"></div>
그리드 영역4
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
    <label><input type="radio" name="receiveRadio" value="S"  checked="checked" /><span>Only selected item(s)</span></label>
    <label><input type="radio" name="receiveRadio" value="A"  /><span>All item(s)</span></label>
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
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_insertReceiveInfo();">SAVE</a></p></li>
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
그리드 영역
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ReceiveCompleteGrid_wrap"></div>
그리드 영역2
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

<article class="tap_area"><!-- tap_area start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="ReceiveIncompleteGrid_wrap"></div>
그리드 영역3
</article><!-- grid_wrap end -->

</article><!-- tap_area end -->

</section><!-- tap_wrap end -->

</section><!-- pop_body end -->

</div><!-- popup_wrap end -->











</section><!-- content end -->

