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


</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var detailGrid;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "7","codeName": "Obsolete"},{"codeId": "67","codeName": "Lost"},{"codeId": "8","codeName": "Inactive"}];
    var categorycomboData = [{"codeId": "1199","codeName": "IT Equipment"}];
    //var instockgradecomboData = [{"codeId": "A","codeName": "A"}];
    
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
        
        doDefCombo(comboData, '' ,'searchstatus', 'M', 'f_multiCombo');
        $("#searchstatus option:eq(0)").prop("selected", true);
        
        doGetCombo('/common/selectCodeList.do', '111', '','searchtype', 'M' , 'f_multiCombo'); //Type 리스트 조회
        $("#searchtype").attr("disabled",true);
        
        doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','searchdealer', 'S' , '');//dealer 
        doGetCombo('/common/selectCodeList.do', '112', '','searchcolor', 'S' , ''); //Color 리스트 조회
        doGetCombo('/common/selectCodeList.do', '112', '','mastercolor', 'S' , ''); //Color 리스트 조회
        doGetCombo('/common/selectCodeList.do', '111', '','mastertype', 'S' , ''); //Type 리스트 조회
        //doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','masterdealer', 'S' , '');//dealer 리스트 조회
        doGetCombo('/logistics/assetmng/selectBrandList.do', '', '','masterbrand', 'S' , '');//brand 리스트 조회
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
        
        AUIGrid.bind(myGridID, "cellClick", function( event ) 
        {
            
            
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
            var selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
             	div="V";
            	$("#detailHead").text("AssetMng Information Details");
                fn_setVisiable(div); 
            	fn_assetDetail(selectedItem[0]);
            }else{
            Common.alert('Choice Data please..');
            }
           $("#masterWindow").show();
        });
       
        /* 팝업 드래그 start */
        $("#popup_wrap, .popup_wrap").draggable({handle: '.pop_header'});
        /* 팝업 드래그 end */
        });
                
	    $(function(){
	        $("#search").click(function(){
	            getAssetListAjax();    
	        });
	        $("#clear").click(function(){
	          /*   doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
	            doDefCombo(comboData, '' ,'status', 'S', '');
	            $("#loccd").val('');
	            $("#locdesc").val(''); */
	        });
               
         $("#insert").click(function(){
          // fn_insertWare();
           div="N";
           $("#detailHead").text("Courier Information New");
           fn_setVisiable(div);
           $("#masterWindow").show();
          });
         $("#savePopbtn").click(function(){
             //$("#editWindow").hide();
                div="N";
                assetsaveAjax(div);
                $("#editWindow").hide();
               
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
                   
    });
    
    function getAssetListAjax() {
        f_showModal();
        var url = "/logistics/assetmng/assetList.do";
        var param = $('#searchForm').serializeJSON();
        Common.ajax("POST" , url , param , function(data){
             var gridData = data             
            console.log(gridData.data);            
            AUIGrid.setGridData(myGridID, gridData.data);
            hideModal();
        });
    }
    
    function assetsaveAjax(div) {
        var url;
        var key;
        var val= $("#masterForm").serializeJSON();
        selectedItem = AUIGrid.getSelectedIndex(myGridID);
       if(div=="U"){
           //url="/logistics/assetmng/motifyCourier.do";
       }else if(div=="N"){
    	   alert("인서트 중입니다!!!!");
           url="/logistics/assetmng/insertAssetMng.do";
       }
       Common.ajax("POST",url,val,function(result){
           Common.alert(result.msg);
        /*    $("#search").trigger("click");
           if(div=="U"){
                 $("#view").click();
          } */
       });
   } 
    
    
    
    function fn_setValuePop(setVal){
        $("#curcode").val(setVal[0].curierCode);
        $("#curname").val(setVal[0].curierName);
        $("#curregno").val(setVal[0].curierRegNo);
        doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , setVal[0].curierCntyId,'curcntyid', 'S', ''); 
        getAddrRelay( 'curstateid' , setVal[0].curierCntyId , 'state' , setVal[0].curierStateId);
        getAddrRelay( 'curareaid' , setVal[0].curierStateId , 'area' , setVal[0].curierAreaId);
        getAddrRelay( 'curpostcod' , setVal[0].curierAreaId , 'post' ,  setVal[0].curierPostCodeId);
        
        $("#curcntcno1").val(setVal[0].curierCntcNo1);
        $("#curcntcno2").val(setVal[0].curierCntcNo2);
        $("#curfaxno").val(setVal[0].curierFaxNo);
        $("#curemail").val(setVal[0].curierEmail);
        $("#curadd1").val(setVal[0].curierAdd1);
        $("#curadd2").val(setVal[0].curierAdd2);
        $("#curadd3").val(setVal[0].curierAdd3);  
            
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
        //doGetCombo('/logistics/assetmng/selectDealerList.do', '1', AUIGrid.getCellValue(myGridID ,rowid,'dealername'),'masterdealer', 'S' , '');//dealer 
        alert(AUIGrid.getCellValue(myGridID ,rowid,'dealername'));
    }
    function fn_assetDetailCancel(){
        $( "#masterWindow" ).hide();
    }
    
    
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
    
     function f_multiCombo() {
         $(function() {
             $('#searchstatus').change(function() {

             }).multipleSelect({
                 selectAll : true, // 전체선택 
                 width : '80%'
             });
             $('#searchtype').change(function() {

             }).multipleSelect({
                 selectAll : true,
                 width : '80%'
             });
         /*     $('#cmbStatus').change(function() {

             }).multipleSelect({
                 selectAll : true,
                 width : '80%'
             }); */
         });
     }
     
     function fn_setVisiable(div){
         if(div=="V"){
               $("#masterstatus").prop('readonly', true);
               $("#masterbreanch").prop('readonly', true);
               $("#masterdepartment").prop('readonly', true);
               $("#masteruser").prop('readonly', true);
               $("#mastercategory").prop('disabled', true);
               $("#mastertype").prop('disabled', true);
               $("#mastermodelname").prop('readonly', true);
               $("#mastercolor").prop('disabled', true);
               $("#masterinvoiceno").prop('readonly', true);
               //$("#masterdealer").prop('disabled', true);
               $("#masterpurchasedate").prop('disabled', true);
               $("#masterbrand").prop('readonly', true);
               $("#masterpurchaseamount").prop('readonly', true);
               $("#masterrefno").prop('readonly', true);
               $("#masterserialno").prop('readonly', true);
               $("#masterwarrantyno").prop('readonly', true);
               $("#mastermacaddress").prop('readonly', true);
               $("#masterimeino").prop('readonly', true);
               $("#masterremark").prop('readonly', true);
               $("#trinserthide1").show(); 
               $("#trinserthide2").show(); 
               $("#savePopbtn").hide();
               $("#updatePopbtn").hide();
               combReset(div);
         }else if(div=="U"){
             $("#curcode").prop('readonly', true);
             $("#curname").prop('readonly', false);
             $("#curregno").prop('readonly', false);
             $("#curcntyid").prop('disabled', false);
             $("#curstateid").prop('disabled', false);
             $("#curareaid").prop('disabled', false);
             $("#curpostcod").prop('disabled', false);
             $("#curcntcno1").prop('readonly', false);
             $("#curcntcno2").prop('readonly', false);
             $("#curfaxno").prop('readonly', false);
             $("#curemail").prop('readonly', false);
             $("#curadd1").prop('readonly', false);
             $("#curadd2").prop('readonly', false);
             $("#curadd3").prop('readonly', false);
             $("#mastercategory").hide();
             $("#updatePopbtn").show();
             $("#savePopbtn").hide();
         }else if(div=="N"){
         	 $('#masterForm')[0].reset();
        	 $("#trinserthide1").hide(); 
        	 $("#trinserthide2").hide();
        	 $("#mastercategory").prop('disabled', false);
        	 $("#mastertype").prop('disabled', false);
             $("#mastermodelname").prop('readonly', false);
             $("#mastercolor").prop('disabled', false);
             $("#masterinvoiceno").prop('readonly', false);
             $("#masterdealer").prop('disabled', false);             
             $("#masterpurchasedate").prop('disabled', false);       
             $("#masterbrand").prop('readonly', false);        
             $("#masterpurchaseamount").prop('readonly', false);
             $("#masterrefno").prop('readonly', false);            
             $("#masterserialno").prop('readonly', false);
             $("#masterwarrantyno").prop('readonly', false);
             $("#mastermacaddress").prop('readonly', false);
             $("#masterimeino").prop('readonly', false);
             $("#masterremark").prop('readonly', false); 
             $("#savePopbtn").show();
             $("#updatePopbtn").hide();
             
             combReset(div);
         }
     }
     function combReset(){
    	 if(div=="V"){
    		 alert("조회 콤보");
    	    
   		   //doGetCombo('/logistics/assetmng/selectBrandList.do', '', '','masterbrand', 'S' , '');//brand
           //doGetCombo('/common/selectCodeList.do', '111', '','mastertype', 'S' , ''); //Type 리스트 조회
           //doGetCombo('/common/selectCodeList.do', '112', '','mastercolor', 'S' , ''); //Color 리스트 조회
           //doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','masterdealer', 'S' , '');//dealer
           //doDefCombo(categorycomboData, '' ,'mastercategory', 'S', '');
           //doDefCombo('', '' ,'masterdealer', 'S', '');
    	}else if(div=="N"){
    		alert("인서트 콤보");
    	   doGetCombo('/logistics/assetmng/selectBrandList.do', '', '','masterbrand', 'S' , '');//brand
    	   doGetCombo('/common/selectCodeList.do', '111', '','mastertype', 'S' , ''); //Type 리스트 조회
           doGetCombo('/common/selectCodeList.do', '112', '','mastercolor', 'S' , ''); //Color 리스트 조회
           doGetCombo('/logistics/assetmng/selectDealerList.do', '1', '','masterdealer', 'S' , '');//dealer
           doDefCombo(categorycomboData, '' ,'mastercategory', 'S', '');
         /*   doDefCombo('', '' ,'curstateid', 'S', ''); 
           doDefCombo('', '' ,'curareaid', 'S', '');
           doDefCombo('', '' ,'curpostcod', 'S', '');    */	
    	}
}
     
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
<h2>Asset Management</h2>
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
    <input type="text" id="assetid" name="assetid" title="Code" placeholder="Asset ID(Number Only)" class="w100p" />
    </td>
    <th scope="row">Status</th>
    <td>
    <select class="w100p" id="searchstatus" name="searchstatus">
    </select>
    </td>
    <th scope="row">Brand</th>
    <td>
    <input type="text" id="searchbrand" name="searchbrand" placeholder="Brand"  class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Category</th>
    <td>
    <select id="" name="" onchange="getAddrRelay('searchtype' , this.value , 'type', this.value)"  title="" placeholder="Category" class="w100p" >
    </select>
    </td>
    <th scope="row">Type</th>
    <td>
    <select id="searchtype" name="searchtype" placeholder="Type" class="w100p">
    </select>
    </td>
    <th scope="row">Color</th>
    <td>
    <select id="searchcolor" name="searchcolor" placeholder="Color" class="w100p" >
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Model Name</th>
    <td>
    <input type="text" id="searchmodelname" name="searchmodelname" title="Code" placeholder="Model Name" class="w100p" />
    </td>
    <th scope="row">Purchase Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="searchpurchasedate1" name="searchpurchasedate1" type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
    <span>to</span>
    <p><input id="searchpurchasedate2" name="searchpurchasedate2"  type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
    </div><!-- date_set end -->
    </td>
    <th scope="row">Ref No</th>
    <td>
     <input type="text"  id="searchrefno"  name="searchrefno" class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Branch</th>
    <td>
    <select id="branchid" name="branchid" class="w100p" >
    </select>
    </td>
    <th scope="row">Department</th>
    <td>
    <select class="w100p" id="" name="">
    </select>
    </td>
    <th scope="row"></th>
    <td>
    <input type="text"  id=""  name="" class="w100p" readonly />
    </td>
</tr>
<tr>
    <th scope="row">Invoice No</th>
    <td>
    <input type="text" id="" name="" title="" placeholder="Invoice No" class="w100p" />
    </td>
    <th scope="row">Dealer</th>
    <td>
    <select id="searchdealer" name="searchdealer" placeholder="Dealer" class="w100p" >
    </select>
    </td>
    <th scope="row"></th>
    <td>
    <input type="text" id=""  name="" class="w100p"  readonly />
    </td>
</tr>
<tr>
    <th scope="row">Serial No</th>
    <td>
    <input type="text" id="" name="" title="" placeholder="Serial Number" class="w100p" />
    </td>
    <th scope="row">Warranty No</th>
    <td>
    <input type="text" id="" name="" placeholder="Warranty Number" class="w100p"/>
    </td>
    <th scope="row">IMEI No</th>
    <td>
    <input type="text" id=""  name="" placeholder="IMEI Number" class="w100p"/>
    </td>
</tr>
<tr>
    <th scope="row">Mac Address</th>
    <td>
    <input type="text" id="" name="" title="" placeholder="MAC Address" class="w100p" />
    </td>
    <th scope="row">Creator</th>
    <td>
   <input type="text" id="" name="" placeholder="Creator(Username)"  class="w100p">
    </select>
    </td>
    <th scope="row">Create Date</th>
    <td>
    <div class="date_set w100p"><!-- date_set start -->
    <p><input id="searchcreatedate1" name="searchcreatedate1" type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly /></p>
    <span>to</span>
    <p><input id="searchcreatedate2" name="searchcreatedate2"  type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly  /></p>
    </div><!-- date_set end -->
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
<h1 id="detailHead"></h1>
<ul class="right_opt">
    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
</ul>
</header><!-- pop_header end -->
<section class="pop_body"><!-- pop_body start -->

<form id="masterForm" name="masterForm" method="POST">
<table class="type1"><!-- table start -->
<caption>search table</caption>
<colgroup>
    <col style="width:120px" />
    <col style="width:*" />
    <col style="width:120px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr id="trinserthide1"> 
    <th scope="row">Assert Status</th>
    <td colspan="2" id="tdassertstatus"><input type="text" title="" placeholder=""  class="w100p" id="masterstatus" name="assetstatus"/></td>
    <th scope="row">Breanch (Belong To)</th>
    <td colspan="2" id="tdbreanch"><input type="text" title="" placeholder=""  class="w100p" id="masterbreanch" name="masterbreanch"/></td>  
</tr>
<tr id="trinserthide2">
    <th scope="row">Department (Belong To)</th>
    <td colspan="2" id="tddepartment"><input type="text" title="" placeholder=""  class="w100p" id="masterdepartment" name="masterdepartment"/></td>
    <th scope="row">User (Belong To)</th>
    <td colspan="2" id="tduser"><input type="text" title="" placeholder=""  class="w100p" id="masteruser" name="masteruser"/></td>     
</tr>
<tr>
    <th scope="row">Category</th>
    <td colspan="2" id="tdcategory">
    <!-- <input type="text" title="" placeholder=""  class="w100p" id="mastercategory" name="mastercategory"> -->
    <select id="mastercategory" name="mastercategory" title="" placeholder=""  class="w100p">
    </select>  
    </td>
    <th scope="row">Type</th>
    <td colspan="2" id="tdtype"><!-- <input type="text" title="" placeholder=""  class="w100p" id="mastertype" name="mastertype"/> -->
    <select id="mastertype" name="mastertype" title="" placeholder=""  class="w100p">
    </select>
    </td>     
</tr>
<tr>
    <th scope="row">Model Name</th>
    <td colspan="2" id="tdmodelname"><input type="text" title="" placeholder=""  class="w100p" id="mastermodelname" name="mastermodelname"/></td>
    <th scope="row">Color</th>
    <td colspan="2" id="tdcolor"><!-- <input type="text" title="" placeholder=""  class="w100p" id="mastercolor" name="mastercolor"/> -->
    <select id="mastercolor" name="mastercolor" title="" placeholder=""  class="w100p">
    </select>
    </td>     
</tr>
<tr>
    <th scope="row">Invoice No</th>
    <td colspan="2" id="tdinvoiceno"><input type="text" title="" placeholder=""  class="w100p" id="masterinvoiceno" name="masterinvoiceno"/></td>
    <th scope="row">Dealer</th>
    <td colspan="2" id="tddealer"><!-- <input type="text" title="" placeholder=""  class="w100p" id="masterdealer" name="masterdealer"/> -->
    <select id="masterdealer" name="masterdealer" title="" placeholder=""  class="w100p">
    </select>
    </td>     
</tr>
<tr>
    <th scope="row">Purchase Date</th>
    <td colspan="2" id="tdpurchase date"><!-- <input type="text" title="" placeholder=""  class="w100p" id="masterpurchasedate" name="masterpurchasedate"/> -->
    <input id="masterpurchasedate" name="masterpurchasedate" type="text" title="" placeholder="DD/MM/YYYY" class="j_date" readonly />
    </td>
    <th scope="row">Brand</th>
    <td colspan="2" id="tdbrand"><!-- <input type="text" title="" placeholder=""  class="w100p" id="masterbrand" name="masterbrand"/> -->
     <select id="masterbrand" name="masterbrand" title="" placeholder=""  class="w100p">
    </select>
    </td>     
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

</tbody>
</table><!-- table end -->
<ul class="center_btns">
    <li><p class="btn_blue2 big"><a id="savePopbtn">SAVE</a></p></li>
    <li><p class="btn_blue2 big"><a id="updatePopbtn">UPDATE</a></p></li>
    <li><p class="btn_blue2 big"><a onclick="javascript:fn_assetDetailCancel();">CANCEL</a></p></li>
</ul>
</form>

</section>
</div>

</section><!-- content end -->

