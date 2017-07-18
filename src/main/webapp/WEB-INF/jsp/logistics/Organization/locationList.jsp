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
    
    // 수정창
    var dialog;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "8","codeName": "Inactive"}];
    var stockgradecomboData = [{"codeId": "A","codeName": "A"},{"codeId": "B","codeName": "B"}];
    
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"locid"      ,headerText:"WHID"           ,width:"8%"  ,height:30 , visible:true},
                        {dataField:"loccd"      ,headerText:"Code"           ,width:"12%" ,height:30 , visible:true},
                        {dataField:"locdesc"    ,headerText:"Description"    ,width:"40%" ,height:30 , visible:true},
                        {dataField:"locaddr1"   ,headerText:"locaddr1"       ,width:120 ,height:30 , visible:false},
                        {dataField:"locaddr2"   ,headerText:"locaddr2"       ,width:140 ,height:30 , visible:false},
                        {dataField:"locaddr3"   ,headerText:"locaddr3"       ,width:120 ,height:30 , visible:false},
                        {dataField:"locarea"    ,headerText:"locarea"        ,width:120 ,height:30 , visible:false},
                        {dataField:"locpost"    ,headerText:"locpost"        ,width:120 ,height:30 , visible:false},
                        {dataField:"locstat"    ,headerText:"locstat"        ,width:120 ,height:30 , visible:false},
                        {dataField:"loccnty"    ,headerText:"loccnty"        ,width:90  ,height:30 , visible:false},
                        {dataField:"loctel1"    ,headerText:"loctel1"        ,width:90  ,height:30 , visible:false},
                        {dataField:"loctel2"    ,headerText:"loctel2"        ,width:120 ,height:30 , visible:false},
                        {dataField:"loc_branch" ,headerText:"loc_branch"     ,width:100 ,height:30 , visible:false},
                        {dataField:"loctype"    ,headerText:"loctype"        ,width:100 ,height:30 , visible:false},
                        {dataField:"locgrad"    ,headerText:"locgrad"        ,width:100 ,height:30 , visible:false},
                        {dataField:"locuserid"  ,headerText:"locuserid"      ,width:100 ,height:30 , visible:false},
                        {dataField:"locupddt"   ,headerText:"locupddt"       ,width:100 ,height:30 , visible:false},
                        {dataField:"code2"      ,headerText:"code2"          ,width:100 ,height:30 , visible:false},
                        {dataField:"desc2"      ,headerText:"desc2"          ,width:100 ,height:30 , visible:false},
                        {dataField:"areanm"     ,headerText:"areanm"         ,width:100 ,height:30 , visible:false},
                        {dataField:"postcd"     ,headerText:"postcd"         ,width:100 ,height:30 , visible:false},
                        {dataField:"code"       ,headerText:"code"           ,width:100 ,height:30 , visible:false},
                        {dataField:"name"       ,headerText:"name"           ,width:100 ,height:30 , visible:false},
                        {dataField:"countrynm"  ,headerText:"countrynm"      ,width:100 ,height:30 , visible:false},
                        {dataField:"branchcd"   ,headerText:"branchcd"       ,width:100 ,height:30 , visible:false},
                        {dataField:"branchnm"   ,headerText:"Branch"         ,width:"15%" ,height:30 , visible:true},
                        {dataField:"dcode"      ,headerText:"dcode"          ,width:100 ,height:30 , visible:false},
                        {dataField:"descr"      ,headerText:"descr"          ,width:100 ,height:30 , visible:false},
                        {dataField:"codenm"     ,headerText:"Type"           ,width:"15%" ,height:30 , visible:true},
                        {dataField:"statnm"     ,headerText:"Status"         ,width:"10%" ,height:30 , visible:true},
                        {dataField:"locstus"    ,headerText:"locstus"        ,width:100 ,height:30 , visible:false},
                        {dataField:"user_name"  ,headerText:"nser_name"      ,width:100 ,height:30 , visible:false}
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
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
		myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
		detailGrid  = GridCommon.createAUIGrid("stockBalanceGrid", detailLayout,"", gridoptions);
		
		doDefCombo(comboData, '' ,'status', 'S', '');
		
		doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
		
		AUIGrid.bind(myGridID, "cellClick", function( event ) 
	    {
	        fn_locDetail(AUIGrid.getCellValue(myGridID , event.rowIndex , "locid"));
	        
	    });

		// 셀 더블클릭 이벤트 바인딩
	    AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
	    {
	    	fn_modyWare(event.rowIndex);
	    });
	    
		dialog = $( "#editWindow" ).dialog({
		      autoOpen: false,
		      height: 540,
		      width: 800,
		      modal: true,
		      headerHeight:40,
		      position : { my: "center", at: "center", of: $("#grid_wrap") },
		      buttons: {
		        "확인": function(event){alert('1');},
		        "취소": function(event) {
		          dialog.dialog( "close" );
		        }
		      }
		    });

    });

    $(function(){
        $("#search").click(function(){
        	getLocationListAjax();
        });
        $("#clear").click(function(){
        	doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','branchid', 'S' , ''); //청구처 리스트 조회
        	doDefCombo(comboData, '' ,'status', 'S', '');
        	$("#loccd").val('');
        	$("#locdesc").val('');
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
    
    function fn_modyWare(rowid){
    	console.log(AUIGrid.getCellValue(myGridID ,rowid,'statnm'));
    	$("#mstatus").text(AUIGrid.getCellValue(myGridID ,rowid,'statnm'));
    	$("#mwarecd").val(AUIGrid.getCellValue(myGridID ,rowid,'locid'));
    	$("#mwarenm").val(AUIGrid.getCellValue(myGridID ,rowid,'locdesc'));
    	$("#maddr1").val(AUIGrid.getCellValue(myGridID ,rowid,'locaddr1'));
    	$("#maddr2").val(AUIGrid.getCellValue(myGridID ,rowid,'locaddr2'));
    	$("#maddr3").val(AUIGrid.getCellValue(myGridID ,rowid,'locaddr3'));
    	$("#mcontact1").val(AUIGrid.getCellValue(myGridID ,rowid,'loctel1'));
    	$("#mcontact2").val(AUIGrid.getCellValue(myGridID ,rowid,'loctel2'));
    	
    	doDefCombo(stockgradecomboData, '' ,'mstockgrade', 'S', '');
    	
    	doGetComboAddr('/common/selectAddrSelCodeList.do', 'country' , '' , AUIGrid.getCellValue(myGridID ,rowid,'loccnty'),'mcountry', 'S', ''); 
    	
    	if (AUIGrid.getCellValue(myGridID ,rowid,'loccnty') != "" && AUIGrid.getCellValue(myGridID ,rowid,'loccnty') != undefined){
    		getAddrRelay('state' , AUIGrid.getCellValue(myGridID ,rowid,'loccnty') , 'mstate' , AUIGrid.getCellValue(myGridID ,rowid,'locstat'));
    	}
    	if (AUIGrid.getCellValue(myGridID ,rowid,'locstat') != "" && AUIGrid.getCellValue(myGridID ,rowid,'locstat') != undefined){
            getAddrRelay('area' , AUIGrid.getCellValue(myGridID ,rowid,'locstat') , 'marea' , AUIGrid.getCellValue(myGridID ,rowid,'locarea'));
        }
    	if (AUIGrid.getCellValue(myGridID ,rowid,'locarea') != "" && AUIGrid.getCellValue(myGridID ,rowid,'locarea') != undefined){
            getAddrRelay('post' , AUIGrid.getCellValue(myGridID ,rowid,'locarea') , 'mpostcd', AUIGrid.getCellValue(myGridID ,rowid,'locpost'));
        }
    	
    	doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , AUIGrid.getCellValue(myGridID ,rowid,'branchcd'),'mwarebranch', 'S' , ''); 
        dialog.dialog( "open" );
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
    
    function fn_detailView(data){
    	var detail = data.data;
    	var stock = data.stock;
    	console.log(detail[0]);
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
        if (fullAddr != "" && detail[0].countrynm != ""&& detail[0].countrynm != "undefined "){
            fullAddr += " " + detail[0].countrynm
        }
        $("#txtaddress").text(fullAddr);
        $("#txtcontact2").text(detail[0].loctel2);
        
        AUIGrid.setGridData(detailGrid, stock);
    }
    
    function getLocationListAjax() {
        f_showModal();
        var param = $('#searchForm').serialize();
        console.log(param);
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
                alert("실패하였습니다.");
            },
            complete: function(){
                hideModal();
            }
        });       
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
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.del' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.ins' /></a></p></li>
    <li><p class="btn_grid"><a href="#"><spring:message code='sys.btn.add' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

<article id="detailView">
<div class="divine_auto"><!-- divine_auto start -->

<div style="width:55%;">

<aside class="title_line"><!-- title_line start -->
<h3>Warehouse Information</h3>
</aside><!-- title_line end -->

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
</div>

<div style="width:43%;">

<aside class="title_line"><!-- title_line start -->
<h3>Warehouse Information</h3>
</aside><!-- title_line end -->

<div id="stockBalanceGrid"></div>
</div>

</div><!-- divine_auto end -->
</article>

</section><!-- search_result end -->


<section class="pop_body"><!-- pop_body start -->
<div id="editWindow" style="display:none" title="그리드 수정 사용자 정의">
<h1>Warehouse Information</h1>
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
    <td colspan="3"><span  id="mstatus"></span></td>
</tr>
<tr>
    <th scope="row">Warehouse Code</th>
    <td colspan="3"><input type="text" name="mwarecd" id="mwarecd"/></td>    
</tr>
<tr>
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
    <td><select id="mstate" onchange="getAddrRelay('marea' , this.value , 'area', '')" disabled=true><option>Choose One</option></select></td>
</tr>
<tr>
    <th scope="row">Area</th>
    <td><select id="marea" onchange="getAddrRelay('mpostcd' , this.value , 'post', '')" disabled=true><option>Choose One</option></select></td>
    <th scope="row">Postcode</th>
    <td><select id="mpostcd" disabled=true><option>Choose One</option></select></td>
</tr>
<tr>
    <th scope="row">Contact No (1)</th>
    <td><input type="text" name="mcontact1" id="mcontact1"/></td>
    <th scope="row">Contact No (2)</th>
    <td><input type="text" name="mcontact2" id="mcontact2"/></td>
</tr>
</tbody>
</table><!-- table end -->
</div>
</section>

</section><!-- content end -->

