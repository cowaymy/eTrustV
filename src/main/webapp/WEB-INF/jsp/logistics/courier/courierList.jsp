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


/* #editWindow {
    font-size:13px;
}
#editWindow label, input { display:block; }
#editWindow input.text { margin-bottom:10px; width:95%; padding: 0.1em;  }
#editWindow fieldset { padding:0; border:0; margin-top:10px; } */
</style>
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    
    var dialog;
    
    var itemdata;
    
    var comboData = [{"codeId": "1","codeName": "Y"},{"codeId": "8","codeName": "N"}];
    var stockgradecomboData = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
    
    // V= 보기, M=수정, N=신규....  
    var div;
    
    var selectedItem; 
    
    // AUIGrid 칼럼 설정             // formatString : "mm/dd/yyyy",    dataType:"numeric", formatString : "#,##0"
     var columnLayout = [
                         {dataField:"courierid",headerText:"courierId",width:100,visible:false },
                         {dataField:"couriercd",headerText:"Code",width:"15%",visible:true },
                         {dataField:"couriernm",headerText:"Name",width:"30%",visible:true,style :"aui-grid-user-custom-left"},
                         {dataField:"regno",headerText:"Reg. No.",width:"15%",visible:true },
                         {dataField:"country",headerText:"Country",width:"10%",visible:true },
                         
                         {dataField:"countryid",headerText:"countryId",width:100,visible:false },
                         {dataField:"state",headerText:"State",width:"15%",visible:true },
                         {dataField:"stateid",headerText:"stateId",width:100,visible:false },
                         {dataField:"area",headerText:"Area",width:"15%",visible:true },
                         {dataField:"areaid",headerText:"areaId",width:100,visible:false },

                         {dataField:"postcd",headerText:"postCd",width:100,visible:false },
                         {dataField:"contactno1",headerText:"contactNo1",width:100,visible:false },
                         {dataField:"contactno2",headerText:"contactNo2",width:100,visible:false },
                         {dataField:"faxno",headerText:"faxNo",width:100,visible:false }
                         
                         ];
    
    
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false , fixedColumnCount:2};
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
       // doGetCombo('/common/selectCodeList.do', '63', '','spgroup', 'A' , ''); 
        //doDefCombo(comboData, '' ,'sused', 'A', '');
        
        AUIGrid.bind(myGridID, "cellClick", function( event ) 
        {   
        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
            f_detailView(event.rowIndex);
        });
        
        AUIGrid.bind(myGridID, "ready", function(event) {
            var rowCount = AUIGrid.getRowCount(myGridID);  
            
            for (var i = 0 ; i < rowCount ; i++){
                var itemtype = AUIGrid.getCellValue(myGridID, i, "itemType");
                
                if (itemtype != null && itemtype != "" && itemtype != undefined){
                    
                    var typeArr = itemtype.split(",");
                    for (var j = 0 ; j < typeArr.length ; j++){
                        
                        $.each(itemdata, function(index,value) {
                            if(typeArr[j] == itemdata[index].codeId ){
                                AUIGrid.setCellValue(myGridID, i, itemdata[index].code , typeArr[j]);
                            }
                        });
                        
                    }
                }
            }
            AUIGrid.resetUpdatedItems(myGridID, "all");
        });
        
         //$("#detailView").hide();
        // searchAjax();
        
        dialog = $( "#detailWindow" ).dialog({
            autoOpen: false,
            height: 500,
            width: 1400,
            modal: true,
            headerHeight:40,
            position : { my: "center", at: "center", of: $("#grid_wrap") },
            buttons: {
              /* "SAVE" , */
              "CANCEL": function(event) {
                dialog.dialog( "close" );
              }
            }
          });
        

    });

    $(function(){
/*         $('#svalue').keypress(function(event) {
            if (event.which == '13') {
                $("#sUrl").val("/logistics/material/materialcdsearch.do");
                Common.searchpopupWin("searchForm", "/common/searchPopList.do","item");
            }
        }); */
        $("#search").click(function(){
            searchAjax();
        });
        $("#clear").click(function(){
            doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
            doDefCombo(comboData, '' ,'status', 'S', '');
            $("#loccd").val('');
            $("#locdesc").val('');
        });
        $("#view").click(function(){
        	div="V";
        	selectedItem = AUIGrid.getSelectedIndex(myGridID);
            if (selectedItem[0] > -1){
	        	fn_openDetail(div,selectedItem[0]);
            }else{
            Common.alert('Choice Data please..');
            }
        });
        /* $("#update").click(function(){
            var updCnt = GridCommon.getEditData(myGridID).update.length;
            for (var i = 0 ; i < updCnt ; i++){
                var make = GridCommon.getEditData(myGridID).update[i];
                
                var itemtypevalue = "";
                if (make.CDTL != undefined && make.CDTL != ""){
                    if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.CDTL; 
                }
                if (make.FINI != undefined && make.FINI != ""){
                    if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.FINI; 
                }if (make.HRI != undefined && make.HRI != ""){
                    if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.HRI; 
                }
                if (make.KSK != undefined && make.KSK != ""){
                    if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.KSK; 
                }if (make.MKT != undefined && make.MKT != ""){
                    if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.MKT; 
                }
                if (make.MISC != undefined && make.MISC != ""){
                    if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.MISC; 
                }if (make.PRD != undefined && make.PRD != ""){
                    if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.PRD; 
                }
                if (make.UNM != undefined && make.UNM != ""){
                    if (itemtypevalue != "")itemtypevalue += ",";
                    itemtypevalue += make.UNM; 
                }
                var rows = AUIGrid.getRowIndexesByValue(myGridID, "itmId", make.itmId);
                
                AUIGrid.setCellValue(myGridID, rows, "itemType" , itemtypevalue);
            }
            
            Common.ajax("POST", "/logistics/material/materialUpdateItemType.do", GridCommon.getEditData(myGridID), function(result) {
                Common.alert(result.message);
                AUIGrid.resetUpdatedItems(myGridID, "all");
                
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }

                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
           // searchAjax("");
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
        $("#delete").click(function(){
            var selectedItems = AUIGrid.getSelectedItems(myGridID);
            for (var i = 0 ; i < selectedItems.length ; i++){
                   AUIGrid.removeRow(myGridID, selectedItems[i].rowIndex);
            }
            Common.ajax("POST", "/logistics/material/materialUpdate.do", GridCommon.getEditData(myGridID), function(result) {
                Common.alert(result.message);
                AUIGrid.resetUpdatedItems(myGridID, "all");
                
            },  function(jqXHR, textStatus, errorThrown) {
                try {
                } catch (e) {
                }

                Common.alert("Fail : " + jqXHR.responseJSON.message);
            });
        });$("#detailsave").click(function(){
            
            if (valiedcheck()){
                var rows = AUIGrid.getRowIndexesByValue(myGridID, "itmId", $("#ditmid").val());
                var checkval = "";
                $("input[id=itemtype]:checked").each(function() {
                    if (checkval != "") checkval += ",";
                    checkval += $(this).val();                
                });
                AUIGrid.setCellValue(myGridID, rows, "itemType"   , checkval);
                AUIGrid.setCellValue(myGridID, rows, "itmName"    , $("#itmname").val());
                AUIGrid.setCellValue(myGridID, rows, "prc"        , $("#price").val());
                AUIGrid.setCellValue(myGridID, rows, "itmDesc"    , $("#itmdesc").val());
                AUIGrid.setCellValue(myGridID, rows, "oldStkId"   , $("#olditemid").val());
                AUIGrid.setCellValue(myGridID, rows, "uom"        , $("#uom").val());
                AUIGrid.setCellValue(myGridID, rows, "currency"   , $("#currency").val());
                AUIGrid.setCellValue(myGridID, rows, "ctgryId"    , $("#cateid").val());
                AUIGrid.setCellValue(myGridID, rows, "stusCodeId" , $("#stuscode").val());
                Common.ajax("POST", "/logistics/material/materialUpdateItemType.do", GridCommon.getEditData(myGridID), function(result) {
                    Common.alert(result.message);
                    AUIGrid.resetUpdatedItems(myGridID, "all");
                    
                },  function(jqXHR, textStatus, errorThrown) {
                    try {
                    } catch (e) {
                    }

                    Common.alert("Fail : " + jqXHR.responseJSON.message);
                });
                //searchAjax(rows);
            }
            
        });
        $("#detailcancel").click(function(){
            var rows = AUIGrid.getRowIndexesByValue(myGridID, "itmId", $("#ditmid").val());
            f_detailView(rows);
        });
        

    });
    
    function f_detailView(rid){
        $("#detailView").show();
        var seldata = AUIGrid.getItemByRowIndex(myGridID , rid);
        
        doGetCombo('/common/selectCodeList.do', '63', seldata.ctgryId ,'cateid', 'S' , '');
        doGetCombo('/common/selectCodeList.do', '94', seldata.uom     ,'uom', 'S' , '');
        doGetCombo('/common/selectCodeList.do', '42', seldata.currency,'currency', 'S' , '');
        doDefCombo(comboData, seldata.stusCodeId ,'stuscode', 'S', '');
        $("#itmcode").val(seldata.itmCode);
        $("#itmname").val(seldata.itmName);
        $("#itmdesc").val(seldata.itmDesc);
        $("#olditemid").val(seldata.oldStkId);
        $("#price").val(seldata.prc);
        $("#ditmid").val(seldata.itmId);
        //itemtypedata
        var html = "";
        var checked = "";
        $.each(itemdata, function(index,value) {
            if (index == 0 || (index % 4) == 0){
                html += "<tr>";
            }
            
            if (seldata.itemType != null && seldata.itemType != "" && seldata.itemType != undefined){
                var typeArr = seldata.itemType.split(",");
                for (var j = 0 ; j < typeArr.length ; j++){
                    if(typeArr[j] == itemdata[index].codeId ){
                        checked = "checked";
                    }
                }
            }
            
            html += "<th scope=\"row\">"+itemdata[index].codeName+"</th>";
            html += "<td>";
            html += "<label><input type=\"checkbox\" id='itemtype' name='itemtype' value='"+itemdata[index].codeId+"' "+checked+"/></label>";
            html += "</td>";
            
            if ((index % 4) == 3){
                html += "</tr>";
            }
            checked = "";
        });
        
        $("#itemtypedata").html(html);
    }
    
    function valiedcheck(){
        if($("#uom").val() == ""){
            Common.alert("Please select one of Unit of Measure.");
            $("#uom").focus();
            return false;
        }
        if($("#currency").val() == ""){
            Common.alert("Please select one of Currency.");
            $("#currency").focus();
            return false;
        }
        if($("#cateid").val() == ""){
            Common.alert("Please select one of Key Product Group.");
            $("#cateid").focus();
            return false;
        }
        if($("#stuscode").val() == ""){
            Common.alert("Please select one of Used.");
            $("#stuscode").focus();
            return false;
        }
        if($("#price").val() == ""){
            Common.alert("Please enter the Sales Price.");
            $("#price").focus();
            return false;
        }
        if($("#itmname").val() == ""){
            Common.alert("Please enter the Material Name.");
            $("#itmname").focus();
            return false;
        }
        
        
        if($("input[id=itemtype]:checked").length == 0){
            Common.alert("Please check one or more Item Type.");
            return false;
        }
        return true;
    }
    function fn_itempop(cd , nm , ct , tp){
        doGetCombo('/common/selectCodeList.do', '63', ct ,'spgroup', 'A' , '');
        $("#svalue").val(cd);
        $("#sname").text(nm);
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
    /* function Start*/
   function searchAjax() {
        f_showModal();
        var url = "/logistics/courier/selectCourierList.do";
        var param = $('#searchForm').serializeJSON();
/*         $.ajax({
            type : "GET",
            url : "/common/selectCodeList.do",
            data : { groupCode : "141"},
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                itemdata = data;
            },
            error: function(jqXHR, textStatus, errorThrown){
            },
            complete: function(){
            }
        }); */
        Common.ajax("POST" , url , param , function(data){
            
            console.log(data.data);
            AUIGrid.setGridData(myGridID, data.data);
            hideModal();
        /*     if (rid != ""){
                AUIGrid.setSelectionByIndex(myGridID, rid, 3);
                f_detailView(rid);
            } */
        });
    }
    
    
    function fn_openDetail(div,idxId){
    	//var id =AUIGrid.getCellValue(myGridID ,idxId, 'courierid');
    	//alert("id +"+id);
    	if(div=="V"){
    		fn_getCourierDetail(idxId);
    		 dialog.dialog( "open" );
    	}else if(div=="M"){
    		
    	}else if(div=="N"){
    		
    	}
    }
    
    function fn_getCourierDetail(id){
    	Common.ajaxSync("GET", "courier/selectCourierDetail", id, 
    			function(data){
    		   console.log("selectCourierDetail :"+ date);
    	});
    }
    
    
    
  
  
</script>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Courier</li>
    <li>Courier List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Courier Search</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm">
<input type="hidden" id="sUrl" name="sUrl">
<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Courier Code</th>
    <td><input type="text" name="srchCourierCd" id="srchCourierCd"  /></td>
    <th scope="row">Courier Name</th>
    <td><input type="text" name="srchCourierNm" id="srchCourierNm"  /></td>
    <th scope="row">Courier Registration No</th>
    <td><input type="text" name="srchRegNo" id="srchRegNo"  /></td>
    <th>Contact No</th>
    <td><input type="text" name="srchcontactNo" id="srchcontactNo"  /></td>
</tr>
<tr>
    <th>Country</th>
    <td><select id="srchCntry"></select>
    </td>
    <th>State</th>
    <td><select  id="srchState"></select></td>
    <th>Area</th>
    <td><select  id="srchArea"></select></td>
    <th>PostCode</th>
    <td><select  id="srchPstCd"></select></td>
</tr>
</tbody>
</table><!-- table end -->
</form>
</section><!-- search_table end -->
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
</aside>

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">

    <%-- <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.up' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    <li><p class="btn_grid"><a id="#"><spring:message code='sys.btn.del' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li> --%>
    <li><p class="btn_grid"><a id="view"><spring:message code='sys.btn.view' /></a></p></li>
    <li><p class="btn_grid"><a id="update"><spring:message code='sys.btn.update' /></a></p></li>
    <li><p class="btn_grid"><a id="insert"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->
                
                
			<section class="pop_body">
				<!-- pop_body start -->
				<div id="detailWindow" style="display: none" title="그리드 수정 사용자 정의">
					<h1>Courier Information</h1>
					<form id="detailForm" name="detailForm" method="POST">
						<!-- <table class="type1">
							table start
							<caption>search table</caption>
							<colgroup>
								<col style="width: 120px" />
								<col style="width: *" />
								<col style="width: 120px" />
								<col style="width: *" />
								<col style="width: 120px" />
								<col style="width: *" />
								<col style="width: 120px" />
								<col style="width: *" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">Courier Code</th>
									<td colspan="3"><span id="mstatus"></span></td>
									<th scope="row">Courier Name</th>
									<td colspan="3"><input type="text" name="mwarecd"
										id="mwarecd" /></td>
									<th scope="row">Courier Registration No</th>
									<td colspan="3"><input type="text" name="mwarenm"
										id="mwarenm" class="w100p" /></td>
								</tr>
								<tr>
									<th scope="row">Contact No. (1)</th>
									<td colspan="3"><select id="mstockgrade"></select></td>
									<th scope="row">Contact No. (2)</th>
									<td colspan="3"><select id="mwarebranch"></select></td>
								</tr>
								<tr>
							         <th scope="row">Fax No.</th> 
									<td colspan="3"><input type="text" id="maddr2"
										name="maddr2" class="w100p" /></td>
								    <th scope="row"> Email  </th>
									<td colspan="3"><input type="text" id="maddr3"
										name="maddr3" class="w100p" /></td>
									<th scope="row">Country</th>
									<td><select id="mcountry"
										onchange="getAddrRelay('mstate' , this.value , 'state', '')"></select></td>
								</tr>
								<tr>
									<th scope="row" rowspan="3">Address</th>
                                    <td colspan="3">1</td>    						
                          						
						  			<th scope="row">State</th>
									<td><select id="mstate" class="msap"
										onchange="getAddrRelay('marea' , this.value , 'area', this.value)"
										disabled=true><option>Choose One</option></select></td>
								</tr>
								<tr>
								<td colspan="3">2</td>                          
                                    
									<th scope="row">Area</th>
									<td colspan="3"><select id="marea" class="msap"
										onchange="getAddrRelay('mpostcd' , this.value , 'post', this.value)"
										disabled=true><option>Choose One</option></select></td>
									<th scope="row">Postcode</th>
									<td colspan="3"><select id="mpostcd" class="msap" disabled=true><option>Choose
												One</option></select></td>
								</tr>
								<tr>
								<td colspan="3">3</td>
								<th scope="row">Area</th>
								<td></td>
								
								</tr>
							</tbody>
						</table>
						table end -->
						<table class="type1"><!-- table start -->
						<caption>search table</caption>
						<colgroup>
						    <col style="width:150px" />
						   <col style="width:*" />
						   <col style="width:160px" />
						   <col style="width:*" />
						   <col style="width:160px" />
						   <col style="width:*" />
						</colgroup>
						<tbody>
						<tr>
						    <th scope="row">Courier Code</th>
						    <td>
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row">Courier Name</th>
						    <td>
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row">Courier Registration No</th>
						    <td>
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						</tr>
						<tr>
						    <th scope="row">Contact No. (1)</th>
						    <td>
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row">Contact No. (2)</th>
						    <td>
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row">Country</th>
						    <td>
						    <select class="w100p">
						        <option value="">11</option>
						        <option value="">22</option>
						        <option value="">33</option>
						    </select>
						    </td>
						</tr>
						<tr>
						    <th scope="row">Fax No.</th>
						    <td>
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row">Email</th>
						    <td>
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row">State</th>
						    <td>
						    <select class="w100p">
						        <option value="">11</option>
						        <option value="">22</option>
						        <option value="">33</option>
						    </select>
						    </td>
						</tr>
						<tr>
						    <th scope="row" rowspan="3">Address</th>
						    <td colspan="3">
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row">Area</th>
						    <td>
						    <select class="w100p">
						        <option value="">11</option>
						        <option value="">22</option>
						        <option value="">33</option>
						    </select>
						    </td>
						</tr>
						<tr>
						    <td colspan="3">
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row">Postcode</th>
						    <td>
						    <select class="w100p">
						        <option value="">11</option>
						        <option value="">22</option>
						        <option value="">33</option>
						    </select>
						    </td>
						</tr>
						<tr>
						    <td colspan="3">
						    <input type="text" title="" placeholder="" class="w100p" />
						    </td>
						    <th scope="row"></th>
						    <td>
						    </td>
						</tr>
						</tbody>
						</table><!-- table end -->
					</form>
				</div>
			</section>

		</section>
