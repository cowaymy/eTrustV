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
#editWindow label, input { display:block; }
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; }
</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var detailGrid;

    // 등록창
    var insDialog;
    // 수정창
    var dialog;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "8","codeName": "Inactive"}];
    var stockgradecomboData = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
    var instockgradecomboData = [{"codeId": "A","codeName": "A"}];
    
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"assetid"      ,headerText:"Asset ID"           ,width:"5%"  ,height:30 , visible:true},
                        {dataField:"name2"      ,headerText:"Status"           ,width:"8%" ,height:30 , visible:true},
                        {dataField:"codename2"    ,headerText:"Type"    ,width:"12%" ,height:30 , visible:true},
                        {dataField:"name"   ,headerText:"Brand"       ,width:120 ,height:30 , visible:true},
                        {dataField:"name1"   ,headerText:"Model Name"       ,width:140 ,height:30 , visible:true},
                        {dataField:"colorid"   ,headerText:"Color"       ,width:90 ,height:30 , visible:true},
                        {dataField:"branch"    ,headerText:"Branch"        ,width:120 ,height:30 , visible:true},
                        {dataField:"department"    ,headerText:"Department"        ,width:140 ,height:30 , visible:true},
                        {dataField:"purchsdt"    ,headerText:"Purchase Date"        ,width:120 ,height:30 , visible:true},
                        {dataField:"username"    ,headerText:"Current User"        ,width:120  ,height:30 , visible:true},
                        {dataField:"refno"    ,headerText:"Ref No"        ,width:120  ,height:30 , visible:true},
                        {dataField:"dealername"    ,headerText:"Dealer"        ,width:120  ,height:30 , visible:true},
                        {dataField:"invcno"    ,headerText:"Inv No"        ,width:120 ,height:30 , visible:true},                     
                        {dataField:"brandid"  ,headerText:"brandId"     ,width:100 ,height:30 , visible:false},
                        {dataField:"ctgryid"    ,headerText:"ctgryId"        ,width:100 ,height:30 , visible:false},                      
                        {dataField:"codename"    ,headerText:"codeName"        ,width:100 ,height:30 , visible:false},                      
                        {dataField:"codename1"  ,headerText:"codeName1"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"crtdt"   ,headerText:"crtDt"       ,width:100 ,height:30 , visible:false},                       
                        {dataField:"crtuserid"      ,headerText:"crtUserId"          ,width:100 ,height:30 , visible:false},
                        {dataField:"currbrnchid"      ,headerText:"currBrnchId"          ,width:100 ,height:30 , visible:false},                        
                        {dataField:"currdeptid"     ,headerText:"currDeptId"         ,width:100 ,height:30 , visible:false},                    
                        {dataField:"curruserid"     ,headerText:"currUserId"         ,width:100 ,height:30 , visible:false},                      
                        {dataField:"username2"       ,headerText:"userName2"           ,width:100 ,height:30 , visible:false},                       
                        {dataField:"imeino"       ,headerText:"imeiNo"           ,width:100 ,height:30 , visible:false},                      
                        {dataField:"macaddr"  ,headerText:"macAddr"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"purchsamt"   ,headerText:"purchsAmt"       ,width:100 ,height:30 , visible:false},                      
                        {dataField:"assetrem"   ,headerText:"assetRem"         ,width:"15%" ,height:30 , visible:false},                       
                        {dataField:"serialno"      ,headerText:"serialNo"          ,width:100 ,height:30 , visible:false},                        
                        {dataField:"stusId"      ,headerText:"stusId"          ,width:100 ,height:30 , visible:false},                 
                        {dataField:"typeid"     ,headerText:"typeId"           ,width:"15%" ,height:30 , visible:false},                   
                        {dataField:"upddt"     ,headerText:"updDt"         ,width:"10%" ,height:30 , visible:false},                      
                        {dataField:"upduserid"    ,headerText:"upd_user_Id"        ,width:100 ,height:30 , visible:false},
                        {dataField:"username1"  ,headerText:"userName1"      ,width:100 ,height:30 , visible:false},                       
                        {dataField:"wrantyno"  ,headerText:"wrantyNo"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"dealerid"  ,headerText:"dealerId"      ,width:100 ,height:30 , visible:false},
                       ];
    
/*     var detailLayout = [{dataField:"stkid"      ,headerText:"stkid"          ,width:"12%" ,height:30 , visible:false},
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
                       ]; */
    
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
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        //detailGrid  = GridCommon.createAUIGrid("stockBalanceGrid", detailLayout,"", gridoptions);
        
        doDefCombo(comboData, '' ,'status', 'S', '');
        
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
        
        AUIGrid.bind(myGridID, "cellClick", function( event ) 
        {
            
            
        });
                
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
            	fn_assetDetail(selectedItem[0]);
            }else{
            Common.alert('Choice Data please..');
            }
        
           $("#masterWindow").show();
          //   fn_assetDetail(AUIGrid.getCellValue(myGridID , event.rowIndex , "assetid"));
       
        });
         
        
/*         AUIGrid.bind(myGridID, "updateRow", function(event) {
            $( "#editWindow" ).hide();
            
            console.log(GridCommon.getEditData(myGridID));
            
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
        }); */
        
        //$("#detailView").hide();

        /* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
        /* 팝업 드래그 end */

    });

    $(function(){
        $("#search").click(function(){
            getAssetListAjax();    
        });
        $("#clear").click(function(){
            doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
            doDefCombo(comboData, '' ,'status', 'S', '');
            $("#loccd").val('');
            $("#locdesc").val('');
        });
        
 /*        $("#update").click(function(){
            $("#detailView").hide();
            
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
                fn_modyWare(selectedItem[0]);
            }else{
            Common.alert('Choice Data please..');
            }
            //AUIGrid.setSelectionByIndex(myGridID, selcell , 3);
        }); */
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
        
    
 /*         $("#insert").click(function(){
             fn_insertWare();
            $("#detailView").hide();
            $("#registWindow").show();
         });     
        
        $("#delete").click(function(){
            $("#detailView").hide();
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
                fn_deleteWare(selectedItem[0]);
            }else{
            Common.alert('Choice Data please..');
            }
          
        });    */  
               
    });
    
  
    
/*     function fn_modyWare(rowid){
        
        $("#mstatus").text(AUIGrid.getCellValue(myGridID ,rowid,'statnm'));
        $("#mwarecd").val(AUIGrid.getCellValue(myGridID ,rowid,'loccd'));
        $("#mwarenm").val(AUIGrid.getCellValue(myGridID ,rowid,'locdesc'));
        $("#maddr1").val(AUIGrid.getCellValue(myGridID ,rowid,'locaddr1'));
        $("#maddr2").val(AUIGrid.getCellValue(myGridID ,rowid,'locaddr2'));
        $("#maddr3").val(AUIGrid.getCellValue(myGridID ,rowid,'locaddr3'));
        $("#mcontact1").val(AUIGrid.getCellValue(myGridID ,rowid,'loctel1'));
        $("#mcontact2").val(AUIGrid.getCellValue(myGridID ,rowid,'loctel2'));
        
        doDefCombo(stockgradecomboData, AUIGrid.getCellValue(myGridID ,rowid,'locgrad') ,'mstockgrade', 'S', '');
        
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , AUIGrid.getCellValue(myGridID ,rowid,'loccnty'),'mcountry', 'S', ''); 
        
        doDefCombo('', '' ,'mstate', 'S', '');
        doDefCombo('', '' ,'marea', 'S', '');
        doDefCombo('', '' ,'mpostcd', 'S', '');
        
        if (AUIGrid.getCellValue(myGridID ,rowid,'loccnty') != "" && AUIGrid.getCellValue(myGridID ,rowid,'loccnty') != undefined){
            getAddrRelay('mstate' , AUIGrid.getCellValue(myGridID ,rowid,'loccnty') , 'state' , AUIGrid.getCellValue(myGridID ,rowid,'locstat'));
        }
        if (AUIGrid.getCellValue(myGridID ,rowid,'locstat') != "" && AUIGrid.getCellValue(myGridID ,rowid,'locstat') != undefined){
            getAddrRelay('marea' , AUIGrid.getCellValue(myGridID ,rowid,'locstat') , 'area' , AUIGrid.getCellValue(myGridID ,rowid,'locarea'));
        }
        if (AUIGrid.getCellValue(myGridID ,rowid,'locarea') != "" && AUIGrid.getCellValue(myGridID ,rowid,'locarea') != undefined){
            getAddrRelay('mpostcd' , AUIGrid.getCellValue(myGridID ,rowid,'locarea') , 'post', AUIGrid.getCellValue(myGridID ,rowid,'locpost'));
        }
        
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , AUIGrid.getCellValue(myGridID ,rowid,'locBranch'),'mwarebranch', 'S' , ''); 
        $( "#editWindow" ).show();
    }
     */
    
/*   function fn_insertWare(){

        doDefCombo(stockgradecomboData, '' ,'instockgrade', 'S', '');
        //$("#instockgrade option:eq(1)").prop("selected", true);
        //$("#instockgrade").attr("disabled",true); 
        
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , 'this.value','inwarebranch', 'S' , ''); //브런치 등록
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , 'this.value','incountry', 'S', ''); //주소 등록
        doDefCombo('', '' ,'instate', 'S', ''); 
        doDefCombo('', '' ,'inarea', 'S', '');
        doDefCombo('', '' ,'inpostcd', 'S', '');    
    } */
  
/*   function fn_deleteWare(rowid){      
      var locid=AUIGrid.getCellValue(myGridID ,rowid,'locid');      
      var param = "?locid="+locid;
        $.ajax({
          type : "POST",
          url : "/logistics/organization/locationDelete.do"+param,
          dataType : "json",               
          contentType : "application/json;charset=UTF-8",
          success : function(result) {
          Common.alert(result.message);
          $("#search").click();
          },
          error: function(jqXHR, textStatus, errorThrown){
              alert("실패하였습니다.");
          }
      });  
      

  }
   */
  
/*   function inValidation(){
   
       var inwarecd = $("#inwarecd").val().trim();
       var inwarenm = $("#inwarenm").val().trim();
       var instockgrade = $("#instockgrade").val().trim();
       var inwarebranch = $("#inwarebranch").val().trim();
       var incontact1 = $("#incontact1").val().trim();  
       var incontact2 = $("#incontact2").val().trim();   
       
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
       if(inaddr1 == null || inaddr1 == "" ){
           Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           $("#inaddr1").focus();
           return false;
     }
       
       if(inwarebranch == null || inwarebranch == "" ){
           Common.alert('Some required fields are empty. Please fill up all the required fields. ');
           $("#inwarebranch").focus();
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
  } */
   

/*     function fn_updateGridRow(){
        //AUIGrid.setSelectionByIndex(myGridID, selcell , 3);
        var item = {};
        var selectedItem = AUIGrid.getSelectedIndex(myGridID);
        
        item.loccd   = $("#mwarecd").val();
        item.locdesc = $("#mwarenm").val();
        item.locaddr1 = $("#maddr1").val();
        item.locaddr2 = $("#maddr2").val();
        item.locaddr3 = $("#maddr3").val();
        item.loctel1  = $("#mcontact1").val();
        item.loctel2  = $("#mcontact2").val();
        item.locgrad  = $("#mstockgrade").val();
        item.loccnty  = $("#mcountry").val();
        item.locstat  = $("#mstate").val();
        item.locarea  = $("#marea").val();
        item.locpost  = $("#mpostcd").val();
        item.locBranch = $("#mwarebranch").val();
        
        AUIGrid.updateRow(myGridID, item, selectedItem[0]);
    } */
    
    function getAssetListAjax() {
        f_showModal();
        var url = "/logistics/assetmng/assetList.do";
        var param = $('#searchForm').serializeJSON();
        Common.ajax("POST" , url , param , function(data){
             var gridData = data;
            console.log(gridData.data);
            AUIGrid.setGridData(myGridID, gridData.data);
            hideModal();
        });
    }
  
    function fn_assetDetail(rowid){   	
    	$("#masterstatus").val(AUIGrid.getCellValue(myGridID ,rowid,'name2'));
    	$("#masterbreanch").val(AUIGrid.getCellValue(myGridID ,rowid,'branch'));
    	$("#masterdepartment").val(AUIGrid.getCellValue(myGridID ,rowid,'department'));
    	$("#masteruser").val(AUIGrid.getCellValue(myGridID ,rowid,'username'));
    	$("#mastercategory").val(AUIGrid.getCellValue(myGridID ,rowid,'codename'));
    	$("#mastertype").val(AUIGrid.getCellValue(myGridID ,rowid,'codename2'));
    	$("#mastermodelname").val(AUIGrid.getCellValue(myGridID ,rowid,'name1'));
    	$("#mastercolor").val(AUIGrid.getCellValue(myGridID ,rowid,'colorid'));
    	$("#masterinvoiceno").val(AUIGrid.getCellValue(myGridID ,rowid,'invcno'));
    	$("#masterdealer").val(AUIGrid.getCellValue(myGridID ,rowid,'dealername'));
        $("#masterpurchasedate").val(AUIGrid.getCellValue(myGridID ,rowid,'purchsdt'));
        $("#masterbrand").val(AUIGrid.getCellValue(myGridID ,rowid,'name'));
        $("#masterpurchaseamount").val(AUIGrid.getCellValue(myGridID ,rowid,'purchsamt'));
        $("#masterrefno").val(AUIGrid.getCellValue(myGridID ,rowid,'refno'));
        $("#masterserialno").val(AUIGrid.getCellValue(myGridID ,rowid,'serialno'));
        $("#masterwarrantyno").val(AUIGrid.getCellValue(myGridID ,rowid,'wrantyno'));
        $("#mastermacaddress").val(AUIGrid.getCellValue(myGridID ,rowid,'macaddr'));
        $("#masterimeino").val(AUIGrid.getCellValue(myGridID ,rowid,'imeino'));
        $("#masterremark").val(AUIGrid.getCellValue(myGridID ,rowid,'assetrem'));
    
    }
    
/*     function fn_detailView(data){
        var detail = data.data;
        var stock = data.stock;
        
        $("#txtwarecode").text(detail[0].loccd);
        $("#txtstockgrade").text(detail[0].locgrad);
        $("#txtwarename").text(detail[0].locdesc);
        $("#txtstatus").text(detail[0].statnm);
        $("#txtbranch").text(detail[0].branchnm +" - "+detail[0].branchnm);
        $("#txtcontact1").text(detail[0].loctel1);
        
        
        var fullAddr = "";
        if (detail[0].locaddr1 != ""&& detail[0].locaddr1 != undefined){
            fullAddr = detail[0].locaddr1; 
        }
        if (fullAddr != "" && detail[0].locaddr2 != "" && detail[0].locaddr2 != undefined){
            fullAddr += " " + detail[0].locaddr2
        }
        if (fullAddr != "" && detail[0].locaddr3 != ""&& detail[0].locaddr3 != undefined){
            fullAddr += " " + detail[0].locaddr3
        }
        if (fullAddr != "" && detail[0].areanm != "" && detail[0].areanm != undefined){
            fullAddr += " " + detail[0].areanm
        }
        if (fullAddr != "" && detail[0].postcd != ""&& detail[0].postcd != undefined){
            fullAddr += " " + detail[0].postcd
        }
        if (fullAddr != "" && detail[0].name != ""&& detail[0].name != undefined){
            fullAddr += " " + detail[0].name
        }
        if (fullAddr != "" && detail[0].countrynm != ""&& detail[0].countrynm != undefined){
            fullAddr += " " + detail[0].countrynm
        }
        $("#txtaddress").text(fullAddr);
        $("#txtcontact2").text(detail[0].loctel2);
        
        AUIGrid.setGridData(detailGrid, stock);
    } */
    
/*     function getLocationListAjax() {
        f_showModal();
        var param = $('#searchForm').serialize();
        
        $.ajax({
            type : "POST",
            url : "/logistics/organization/LocationList.do?"+param,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                var gridData = data;
                console.log(gridData.data);
                AUIGrid.setGridData(myGridID, gridData.data);
            },
            error: function(jqXHR, textStatus, errorThrown){
                alert("실패하였습니다.");
            },
            complete: function(){
                hideModal();
            }
        });       
    } */
     
    
    function f_showModal(){
        $.blockUI.defaults.css = {textAlign:'center'}
        $('div.SalesWorkDiv').block({
                message:"<img src='/resources/images/common/CowayLeftLogo.png' alt='Coway Logo' style='max-height: 46px;width:160px' /><div class='preloader'><i id='iloader'>.</i><i id='iloader'>.</i><i id='iloader'>.</i></div>",
                centerY: false,
                centerX: true,
                css: { top: '300px', border: 'none'} 
        });
    }
    function hideModal(){
        $('div.SalesWorkDiv').unblock();
        
    }
    
    function f_multiCombo(){
        /*$(function() {
            $('#cmbCategory').change(function() {
            //console.log($(this).val());
            }).multipleSelect({
                selectAll: true, // 전체선택 
                width: '80%'
            });
        });*/
    }      
    
 /*     function fn_updateCancel(){
         $( "#editWindow" ).hide();
     }
      */
/*      function fn_insertGrid(){
         
         if(inValidation()){                        
             //$('#instockgrade').attr("disabled",false)
               Common.ajax("GET", "/logistics/organization/insLocation.do", $("#insForm").serialize(), function(result) { 
                Common.alert(result.message);
                $( "#registWindow" ).hide();
                $('#insForm')[0].reset();
                 $("#search").click(); 
                }, function(jqXHR, textStatus, errorThrown) {
                    Common.alert("실패하였습니다.");
                    console.log("실패하였습니다.");
                    console.log("error : " + jqXHR + " \n " + textStatus + "\n" + errorThrown);
                    
                    alert(jqXHR.responseJSON.message);
                    console.log("jqXHR.responseJSON.message" + jqXHR.responseJSON.message);
                  
                    console.log("status : " + jqXHR.status);
                    console.log("code : " + jqXHR.responseJSON.code);
                    console.log("message : " + jqXHR.responseJSON.message);
                    console.log("detailMessage : " + jqXHR.responseJSON.detailMessage);
                    
                });                        
           }
         
     } */
   /*   function fn_insertCancel(){
         $( "#registWindow" ).hide();
     } */
     
</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>AssetMng</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>AssetMng</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">

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
    <th scope="row">Asset ID</th>
    <td>
    <input type="text" id="assetid" name="assetid" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" id="status" name="status">
    </select>
    </td>
    <th scope="row">Brand</th>
    <td>
    <select id="brand" class="w100p" name="brand">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Category</th>
    <td>
    <input type="text" id="loccd" name="loccd" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Type</th>
    <td>
    <select class="w100p" id="branchid" name="branchid">
    </select>
    </td>
    <th scope="row">Color</th>
    <td>
    <select id="status" class="w100p" name="status">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Model Name</th>
    <td>
    <input type="text" id="loccd" name="loccd" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Purchase Date</th>
    <td>
    <select class="w100p" id="branchid" name="branchid">
    </select>
    </td>
    <th scope="row">Ref No</th>
    <td>
    <select id="status" class="w100p" name="status">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <input type="text" id="loccd" name="loccd" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Department</th>
    <td>
    <select class="w100p" id="branchid" name="branchid">
    </select>
    </td>
    <th scope="row"></th>
    <td>
    <select id="status" class="w100p" name="status">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Invoice No</th>
    <td>
    <input type="text" id="loccd" name="loccd" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Dealer</th>
    <td>
    <select class="w100p" id="branchid" name="branchid">
    </select>
    </td>
    <th scope="row"></th>
    <td>
    <select id="status" class="w100p" name="status">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Serial No</th>
    <td>
    <input type="text" id="loccd" name="loccd" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Warranty No</th>
    <td>
    <select class="w100p" id="branchid" name="branchid">
    </select>
    </td>
    <th scope="row">IMEI No</th>
    <td>
    <select id="status" class="w100p" name="status">
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Mac Address</th>
    <td>
    <input type="text" id="loccd" name="loccd" title="Code" placeholder="" class="w100p" />
    </td>
    <th scope="row">Creator</th>
    <td>
    <select class="w100p" id="branchid" name="branchid">
    </select>
    </td>
    <th scope="row">Create Date</th>
    <td>
    <select id="status" class="w100p" name="status">
    </select>
    </td>
</tr>
<!-- <tr>
    <th scope="row">Name</th>
    <td colspan="5">
    <input type="text" id="locdesc" name="locdesc" title="Name" placeholder="" class="w100p" />
    </td>
</tr> -->
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

    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.up' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    <li><p class="btn_grid"><a id="delete"><spring:message code='sys.btn.del' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

<!-- <article id="detailView"> -->
<div class="divine_auto"><!-- divine_auto start -->

<!-- <div style="width:55%;">

<aside class="title_line">title_line start
<h3>Warehouse Information</h3>
</aside>title_line end

<table class="type1">
        <caption>search table</caption>
        <colgroup>
            <col style="width:130px" />
            <col style="width:*" />
            <col style="width:130px" />
            <col style="width:200px" />
        </colgroup>
        <tbody>
        <tr>
            <th scope="row">Warehouse Code</td>
            <td ID="txtwarecode"></td>
            <th scope="row">Stock Grade</td>
            <td ID="txtstockgrade"></td>
        </tr>
        <tr>
            <th scope="row">Warehouse Name</td>
            <td ID="txtwarename"></td>
            <th scope="row">Status</td>
            <td ID="txtstatus"></td>            
        </tr>
        <tr>
            <th scope="row">Branch</td>
            <td ID="txtbranch"></td>
            <th scope="row">Contact (1)</td>
            <td ID="txtcontact1"></td>
        </tr>
        <tr>
            <th scope="row">Address</td>
            <td ID="txtaddress"></td>
            <th scope="row">Contact (2)</td>
            <td ID="txtcontact2"></td>
        </tr>
        </tbody>
    </table>
</div> -->

<div style="width:43%;">

<aside class="title_line"><!-- title_line start -->
<h3>Warehouse Information</h3>
</aside><!-- title_line end -->

<div id="stockBalanceGrid"></div>
</div>

</div><!-- divine_auto end -->
</article>

</section><!-- search_result end -->

<div class="popup_wrap" id="masterWindow" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Warehouse Information</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="modForm" name="modForm" method="POST">
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
    <th scope="row">Assert Status</th>
    <td colspan="2" id="tdassertstatus"><input type="text" title="" placeholder=""  class="w100p" id="masterstatus" name="assetstatus"/></td>
    <th scope="row">Breanch (Belong To)</th>
    <td colspan="2" id="tdbreanch"><input type="text" title="" placeholder=""  class="w100p" id="masterbreanch" name="masterbreanch"/></td>  
</tr>
<tr>
    <th scope="row">Department (Belong To)</th>
    <td colspan="2" id="tddepartment"><input type="text" title="" placeholder=""  class="w100p" id="masterdepartment" name="masterdepartment"/></td>
    <th scope="row">User (Belong To)</th>
    <td colspan="2" id="tduser"><input type="text" title="" placeholder=""  class="w100p" id="masteruser" name="masteruser"/></td>     
</tr>
<tr>
    <th scope="row">Category</th>
    <td colspan="2" id="tdcategory"><input type="text" title="" placeholder=""  class="w100p" id="mastercategory" name="mastercategory"/></td>
    <th scope="row">Type</th>
    <td colspan="2" id="tdtype"><input type="text" title="" placeholder=""  class="w100p" id="mastertype" name="mastertype"/></td>     
</tr>
<tr>
    <th scope="row">Model Name</th>
    <td colspan="2" id="tdmodelname"><input type="text" title="" placeholder=""  class="w100p" id="mastermodelname" name="mastermodelname"/></td>
    <th scope="row">Color</th>
    <td colspan="2" id="tdcolor"><input type="text" title="" placeholder=""  class="w100p" id="mastercolor" name="mastercolor"/></td>     
</tr>
<tr>
    <th scope="row">Invoice No</th>
    <td colspan="2" id="tdinvoiceno"><input type="text" title="" placeholder=""  class="w100p" id="masterinvoiceno" name="masterinvoiceno"/></td>
    <th scope="row">Dealer</th>
    <td colspan="2" id="tddealer"><input type="text" title="" placeholder=""  class="w100p" id="masterdealer" name="masterdealer"/></td>     
</tr>
<tr>
    <th scope="row">Purchase Date</th>
    <td colspan="2" id="tdpurchase date"><input type="text" title="" placeholder=""  class="w100p" id="masterpurchasedate" name="masterpurchasedate"/></td>
    <th scope="row">Brand</th>
    <td colspan="2" id="tdbrand"><input type="text" title="" placeholder=""  class="w100p" id="masterbrand" name="masterbrand"/></td>     
</tr>
<tr>
    <th scope="row">Purchase Amount</th>
    <td colspan="2" id="tdpurchaseamount"><input type="text" title="" placeholder=""  class="w100p" id="masterpurchaseamount" name="masterpurchaseamount"/></td>
    <th scope="row">Ref No</th>
    <td colspan="2" id="tdrefno"><input type="text"  title="" placeholder=""  class="w100p" id="masterrefno" name="masterrefno"/></td>     
</tr>
<tr>
    <th scope="row">Serial No</th>
    <td colspan="2" id="tdserial no"><input type="text" title="" placeholder=""  class="w100p" id="masterserialno" name="masterserialno"/></td>
    <th scope="row">Warranty No</th>
    <td colspan="2" id="tdwarrantyno"><input type="text" title="" placeholder=""  class="w100p" id="masterwarrantyno" name="masterwarrantyno"/></td>     
</tr>
<tr>
    <th scope="row">Mac Address</th>
    <td colspan="2" id="tdmacaddress"><input type="text" title="" placeholder=""  class="w100p" id="mastermacaddress" name="mastermacaddress"/></td>
    <th scope="row">IMEI No</th>
    <td colspan="2" id="tdimei no"><input type="text" title="" placeholder=""  class="w100p" id="masterimeino" name="masterimeino"/></td>     
</tr>
<tr>
    <th scope="row">Remark</th>
    <td colspan="5" id="tdremark"><input type="text" title="" placeholder=""  class="w100p" id="masterremark" name="masterremark"/></td>    
</tr>

<!-- <tr>
    <th scope="row">Warehouse Name</th>
    <td colspan="3"><input type="text" name="mwarenm" id="mwarenm" class="w100p"/></td>
</tr>
<tr>
    <th scope="row">Stock Grade</th>
    <td><select id="mstockgrade"></select></td>
    <th scope="row">Branch</th>
    <td><select id="mwarebranch"></select></td>
</tr>
<tr>
    <th scope="row" rowspan="3">Address</th>
    <td colspan="3"><input type="text" id="maddr1" name="maddr1" class="w100p"/></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="maddr2" name="maddr2" class="w100p"/></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="maddr3" name="maddr3" class="w100p"/></td>
</tr>
<tr>
    <th scope="row">Country</th>
    <td><select id="mcountry" onchange="getAddrRelay('mstate' , this.value , 'state', '')"></select></td>
    <th scope="row">State</th>
    <td><select id="mstate"  class="msap" onchange="getAddrRelay('marea' , this.value , 'area', this.value)" disabled=true><option>Choose One</option></select></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td><select id="marea" class="msap" onchange="getAddrRelay('mpostcd' , this.value , 'post', this.value)" disabled=true><option>Choose One</option></select></td>
    <th scope="row">Postcode</th>
    <td><select id="mpostcd" class="msap" disabled=true><option>Choose One</option></select></td>
</tr>
<tr>
    <th scope="row">Contact No (1)</th>
    <td><input type="text" name="mcontact1" id="mcontact1"/></td>
    <th scope="row">Contact No (2)</th>
    <td><input type="text" name="mcontact2" id="mcontact2"/></td>
</tr> -->
</tbody>
</table><!-- table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_updateGridRow();">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_updateCancel();">CANCEL</a></p></li>
</ul>
</form>

</section>
</div>

<!-- ------------------------------------------------------------------------20170719 추가 함영수------------------------------------------------ -->
<div class="popup_wrap" id="registWindow" style="display:none"><!-- popup_wrap start -->

<header class="pop_header"><!-- pop_header start -->
<h1>Warehouse Information</h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->

<section class="pop_body"><!-- pop_body start -->
<form id="insForm" name="insForm" method="GET">
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
    <th scope="row">Warehouse Code</th>
    <td colspan="3"><input type="text" name="inwarecd" id="inwarecd" maxlength="10"/></td>    
</tr>
<tr>
    <th scope="row">Warehouse Name</th>
    <td colspan="3"><input type="text" name="inwarenm" id="inwarenm" class="w100p"/></td>
</tr>
 <tr>
    <th scope="row">Stock Grade</th>
    <td><select id="instockgrade" name="instockgrade" ></select></td>
    <th scope="row">Branch</th>
    <td><select id="inwarebranch" name="inwarebranch" >
  
    </select></td>
</tr> 
<tr>
    <th scope="row" rowspan="3">Address</th>
    <td colspan="3"><input type="text" id="inaddr1" name="inaddr1" class="w100p"/></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="inaddr2" name="inaddr2" class="w100p"/></td>
</tr>
<tr>
    <td colspan="3"><input type="text" id="inaddr3" name="inaddr3" class="w100p"/></td>
</tr>
 <tr>
    <th scope="row">Country</th>
    <td><select id="incountry" name="incountry" onchange="getAddrRelay('instate' , this.value , 'state', '')"></select></td>
    <th scope="row">State</th>
    <td><select id="instate" name="instate" onchange="getAddrRelay('inarea' , this.value , 'area', this.value)" disabled=true><option>Choose One</option></select></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td><select id="inarea" name="inarea" onchange="getAddrRelay('inpostcd' , this.value , 'post', this.value)" disabled=true><option>Choose One</option></select></td>
    <th scope="row">Postcode</th>
    <td><select id="inpostcd" name="inpostcd" disabled=true><option>Choose One</option></select></td>
</tr>  
<tr>
    <th scope="row">Contact No (1)</th>
    <td><input type="text" name="incontact1" id="incontact1"/></td>
    <th scope="row">Contact No (2)</th>
    <td><input type="text" name="incontact2" id="incontact2"/></td>
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
<!-- ------------------------------------------------------------------------20170719 추가 함영수------------------------------------------------ -->




</section><!-- content end -->

