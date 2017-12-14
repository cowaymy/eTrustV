<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right ;
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
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">


    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var historyGrid;
    var comboDatas = [{"codeId": "Y","codeName": "Y-Exclude Del Info"},{"codeId": "N","codeName": "N-Include Del Info"}];
    var comboData = [{"codeId": "2040","codeName": "MY-Local Pur.Org"},{"codeId": "2041","codeName": "MY-Import(EAST)"},{"codeId": "2042","codeName": "MY-Import(WEST)"}];

    
    var url;
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [
						{dataField:"seqNo" ,headerText:"seqNo",width:120 ,height:30 , visible:false},
						{dataField:"infoRcordNo" ,headerText:"infoRcordNo",width:120 ,height:30 , visible:false},
						{dataField:"vendor" ,headerText:"Vendor",width:120 ,height:30},
						{dataField:"vendorTxt" ,headerText:"Vendor Text",width:120 ,height:30},
						{dataField:"matrlMst" ,headerText:"Material Code",width:120 ,height:30},
						{dataField:"purchsInfoRcordCtgry" ,headerText:"purchsInfoRcordCtgry",width:120 ,height:30, visible:false},

						{dataField:"matrlTxt" ,headerText:"Material code Text",width:350,height:30},
						{dataField:"purchsGrp" ,headerText:"purchsGrp",width:120 ,height:30, visible:false},
						{dataField:"purchsGrpTxt" ,headerText:"purchsGrpTxt",width:120 ,height:30, visible:false},
						{dataField:"markDel" ,headerText:"markDel",width:120 ,height:30, visible:false},
						{dataField:"planDelvryTmDay" ,headerText:"planDelvryTmDay",width:120 ,height:30, visible:false},
						{dataField:"taxCode" ,headerText:"taxCode",width:120 ,height:30, visible:false},
						{dataField:"taxCodeTxt" ,headerText:"taxCodeTxt",width:120 ,height:30, visible:false},
						{dataField:"purchsPrc" ,headerText:"Pur. Price",width:120 ,height:30,style :"aui-grid-user-custom-right"},
						{dataField:"curname" ,headerText:"Currency",width:120 ,height:30},
						{dataField:"condiPrcUnit" ,headerText:"Per",width:120 ,height:30,style :"aui-grid-user-custom-right"},
						{dataField:"validStartDt" ,headerText:"Valid From",width:120 ,height:30},
						{dataField:"validEndDt" ,headerText:"Valid To",width:120 ,height:30},
	                    {dataField:"purchsOrg" ,headerText:"Pur.Org",width:120 ,height:30},
	                    {dataField:"purchsOrgTxt" ,headerText:"Pur.OrgTxt",width:120 ,height:30},
	                    {dataField:"type" ,headerText:"Material Type",width:120 ,height:30},
						{dataField:"cur" ,headerText:"cur",width:120 ,height:30, visible:false},
						{dataField:"condiUnit" ,headerText:"condiUnit",width:120 ,height:30, visible:false},
						{dataField:"prcDterminDtCntrl" ,headerText:"prcDterminDtCntrl",width:120 ,height:30, visible:false},
						{dataField:"stkId" ,headerText:"stkId",width:120 ,height:30, visible:false},
						{dataField:"stkCode" ,headerText:"stkCode",width:120 ,height:30, visible:false},
						{dataField:"stkDesc" ,headerText:"stkDesc",width:120 ,height:30, visible:false},
						{dataField:"stkCtgryId" ,headerText:"stkCtgryId",width:120 ,height:30, visible:false},
						{dataField:"stkTypeId" ,headerText:"stkTypeId",width:120 ,height:30, visible:false},
						{dataField:"stusCodeId" ,headerText:"stusCodeId",width:120 ,height:30, visible:false},
						{dataField:"isSirim" ,headerText:"isSirim",width:120 ,height:30, visible:false},
						{dataField:"isNcv" ,headerText:"isNcv",width:120 ,height:30, visible:false},
						{dataField:"qtyPerCarton" ,headerText:"qtyPerCarton",width:120 ,height:30, visible:false},
						{dataField:"updUserId" ,headerText:"updUserId",width:120 ,height:30, visible:false},
						{dataField:"updDt" ,headerText:"updDt",width:120 ,height:30, visible:false},
						{dataField:"isSynch" ,headerText:"isSynch",width:120 ,height:30, visible:false},
						{dataField:"netWt" ,headerText:"netWt",width:120 ,height:30, visible:false},
						{dataField:"grosWt" ,headerText:"grosWt",width:120 ,height:30, visible:false},
						{dataField:"measureCbm" ,headerText:"measureCbm",width:120 ,height:30, visible:false},
						{dataField:"masterStkId" ,headerText:"masterStkId",width:120 ,height:30, visible:false},
						{dataField:"stkGrad" ,headerText:"stkGrad",width:120 ,height:30, visible:false},
						{dataField:"stkImg" ,headerText:"stkImg",width:120 ,height:30, visible:false},
						{dataField:"bsPoint" ,headerText:"bsPoint",width:120 ,height:30, visible:false},
						{dataField:"unitValu" ,headerText:"unitValu",width:120 ,height:30, visible:false},
						{dataField:"stkCommOsAs" ,headerText:"stkCommOsAs",width:120 ,height:30, visible:false},
						{dataField:"stkCommAs" ,headerText:"stkCommAs",width:120 ,height:30, visible:false},
						{dataField:"stkCommOsBs" ,headerText:"stkCommOsBs",width:120 ,height:30, visible:false},
						{dataField:"stkCommBs" ,headerText:"stkCommBs",width:120 ,height:30, visible:false},
						{dataField:"stkCommOsIns" ,headerText:"stkCommOsIns",width:120 ,height:30, visible:false},
						{dataField:"stkCommIns" ,headerText:"stkCommIns",width:120 ,height:30, visible:false},
						{dataField:"stkAllowSales" ,headerText:"stkAllowSales",width:120 ,height:30, visible:false},
						{dataField:"isSvcStk" ,headerText:"isSvcStk",width:120 ,height:30, visible:false},
						{dataField:"serialChk" ,headerText:"serialChk",width:120 ,height:30, visible:false},
						{dataField:"uom" ,headerText:"uom",width:120 ,height:30, visible:false},

						
						/* 사용 확인 필요*/
						{dataField:"address" ,headerText:"address",width:120 ,height:30, visible:false},
						{dataField:"emailaddress" ,headerText:"emailaddress",width:120 ,height:30, visible:false},
						{dataField:"trnscost" ,headerText:"trnscost",width:120 ,height:30, visible:false},
						{dataField:"cstmcost" ,headerText:"cstmcost",width:120 ,height:30, visible:false},
						{dataField:"otherimprtcost" ,headerText:"otherimprtcost",width:120 ,height:30, visible:false},
						{dataField:"condiunitname" ,headerText:"condiunitname",width:120 ,height:30, visible:false}

                       ];
    
    
    var historyLayout = [ 
                         {dataField:"validStartDt" ,headerText:"Valid From",width:120 ,height:30},
                         {dataField:"validEndDt" ,headerText:"Valid To",width:120 ,height:30},
                         {dataField:"purchsPrc" ,headerText:"Purchase Price",width:120 ,height:30,style :"aui-grid-user-custom-right"},
                         {dataField:"condiPrcUnit" ,headerText:"Condition pricing unit",width:200 ,height:30,style :"aui-grid-user-custom-right"},
                         {dataField:"curname" ,headerText:"Currency",width:120 ,height:30}
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
    var gridoptions = {showStateColumn : false , editable : false, usePaging : false, useGroupingPanel : false,
		  noDataMessage : "<spring:message code='sys.info.grid.noDataMessage'/>"	  
  
  };
    
    var subgridpros = {
            // 페이지 설정
            showStateColumn : false ,
            usePaging : false,                
            //pageRowCount : 10,                
            editable : false,                
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage'/>"
            //enableSorting : true,
           // softRemoveRowMode:false
            };
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        historyGrid = GridCommon.createAUIGrid("history_grid", historyLayout,"", subgridpros);
        //doGetCombo('/common/selectCodeList.do', '15', '','msttype', 'S' , ''); //Type 리스트 조회
        doGetCombo('/common/selectCodeList.do', '15', '', 'msttype', 'M','f_multiCombo'); //Type 리스트 조회  
        doDefCombo(comboDatas, 'Y' ,'excludedelete', 'S', '');
        AUIGrid.bind(myGridID, "cellClick", function( event )  
        {
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
        	f_removeclass();
        	//AUIGrid.destroy(historyGrid);
        	$("#tap_area_01").show();
        	$("#viewseqno").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'seqNo'));
        	$("#viewinforcordno").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'infoRcordNo'));
        	$("#viewvendor").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'vendor'));
        	$("#viewmatrlmst").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'matrlMst'));
        	$("#viewpurchsinforcordctgry").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'purchsInfoRcordCtgry'));
        	$("#viewpurchsorg").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'purchsOrg'));
        	$("#viewpurchsorgtxt").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'purchsOrgTxt'));
        	$("#viewvendortxt").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'vendorTxt'));
        	$("#viewmatrltxt").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'matrlTxt'));
        	$("#viewpurchsgrp").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'purchsGrp'));
        	$("#viewpurchsgrptxt").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'purchsGrpTxt'));
        	$("#viewmarkdel").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'markDel'));
        	$("#viewplandelvrytmday").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'planDelvryTmDay'));
        	$("#viewtaxcode").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'taxCode')+" : "+AUIGrid.getCellValue(myGridID ,event.rowIndex,'taxCodeTxt'));
        	$("#viewtaxcodetxt").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'taxCodeTxt'));
        	$("#viewvalidstartdt").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'validStartDt'));
        	$("#viewvalidenddt").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'validEndDt'));
        	$("#viewpurchsprc").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'purchsPrc'));
        	$("#viewcur").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'cur'));
        	$("#viewcondiprcunit").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'condiPrcUnit'));
        	$("#viewcondiunit").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'condiUnit'));
        	$("#viewprcdtermindtcntrl").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'prcDterminDtCntrl'));
        	$("#viewstkid").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkId'));
        	$("#viewstkcode").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkCode'));
        	$("#viewstkdesc").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkDesc'));
        	$("#viewstkctgryid").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkCtgryId'));
        	$("#viewstktypeid").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkTypeId'));
        	$("#viewtype").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'type'));
        	$("#viewstuscodeid").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stusCodeId'));
        	$("#viewissirim").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'isSirim'));
        	$("#viewisncv").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'isNcv'));
        	$("#viewqtypercarton").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'qtyPerCarton'));
        	$("#viewupduserid").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'updUserId'));
        	$("#viewupddt").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'updDt'));
        	$("#viewissynch").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'isSynch'));
        	$("#viewnetwt").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'netWt'));
        	$("#viewgroswt").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'grosWt'));
        	$("#viewmeasurecbm").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'measureCbm'));
        	$("#viewmasterstkid").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'masterStkId'));
        	$("#viewstkgrad").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkGrad'));
        	$("#viewstkimg").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkImg'));
        	$("#viewbspoint").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'bsPoint'));
        	$("#viewunitvalu").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'unitValu'));
        	$("#viewstkcommosas").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkCommOsAs'));
        	$("#viewstkcommas").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkCommAs'));
        	$("#viewstkcommosbs").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkCommOsBs'));
        	$("#viewstkcommbs").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkCommBs'));
        	$("#viewstkcommosins").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkCommOsIns'));
        	$("#viewstkcommins").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkCommIns'));
        	$("#viewstkallowsales").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'stkAllowSales'));
        	$("#viewissvcstk").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'isSvcStk'));
        	$("#viewserialchk").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'serialChk'));
        	$("#viewuom").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'uom'));
        	
        	$("#viewcurname").text(AUIGrid.getCellValue(myGridID ,event.rowIndex,'curname'));
            //추후 수정 필요
        	$("#viewaddress").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'address'));
        	$("#viewemailaddress").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'emailaddress'));
        	$("#viewtrnscost").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'trnscost'));
        	$("#viewcstmcost").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'cstmcost'));
        	$("#viewotherimprtcost").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'otherimprtcost'));
        	$("#viewcondiunitname").val(AUIGrid.getCellValue(myGridID ,event.rowIndex,'condiunitname'));
            
        	//getHistoryAjax(AUIGrid.getCellValue(myGridID ,event.rowIndex,'matrlMst'));
        });

        $(function(){
            $("#search").click(function(){
                getListAjax();    
            });
            $("#history").click(function(){
            	var selectedItem = AUIGrid.getSelectedIndex(myGridID);
                if(selectedItem[0] < 0 ){
                    Common.alert('Please select data.');
                    return false;
                }else{
	                var matrlMst = AUIGrid.getCellValue(myGridID,  selectedItem[0], "matrlMst");
                	getHistoryAjax(matrlMst);
                } 
            });
            $("#clear").click(function(){
//            	$("#searchForm")[0].reset();  

                doDefCombo(comboData, '' ,'purchasorg', 'S', '');
            	doDefCombo(comboDatas, 'Y' ,'excludedelete', 'S', '');
            	doGetCombo('/common/selectCodeList.do', '15', '', 'msttype', 'M','f_multiCombo'); //Type 리스트 조회
                $("#vendercd").val('');
                $("#mstcd").val('');
            });
     
            $("#download").click(function() {
                GridCommon.exportTo("grid_wrap", 'xlsx', "Purchase Price List");
            });
        }); 
    }); 
    function getListAjax() {
        var url = "/logistics/purchase/purchasePriceList.do";
        var param = $("#searchForm").serialize();
        console.log(param);
        Common.ajax("GET" , url , param , function(data){
            var list= data.dataList
            AUIGrid.setGridData(myGridID, list);
        });
    }

    
     function getHistoryAjax(matr) {
         var param = "?mstcd="+matr; 
         $.ajax({
            type : "GET",
            url : "/logistics/purchase/purchasePriceHistoryList.do" + param,
            dataType : "json",
            contentType : "application/json;charset=UTF-8",
            success : function(data) {
                     var list= data.dataList
                      AUIGrid.clearGridData(historyGrid);
                     AUIGrid.setGridData(historyGrid, list);      
                     AUIGrid.resize(historyGrid); 
                     
            },
            error : function(jqXHR, textStatus, errorThrown) {
                alert("실패하였습니다.");
            },
           
        }); 
     }   
     
     function f_removeclass(){
         var lisize = $(".tap_wrap > ul > li").size();
         for (var i = 0 ; i < lisize ; i++){
             $(".tap_wrap > ul > li").eq(i).find("a").removeAttr("class");
         }
         
        /*  var r = $(".tap_wrap > .tap_area").size();
         for(var i = 0 ; i < r ; i++){
             $(".tap_wrap > .tap_area").eq(i).hide();
         }  */
        // $("#basic").attr("class","on");
         $("#basic").click();
     }
     
     function f_multiCombo() {
    	    $(function() {
    	        $('#msttype').change(function() {
    	        }).multipleSelect({
    	            selectAll : true,
    	            width: '100%'
    	        })      
    	    });
    	}   
</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>PurchasePrice</li>

</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Purchase Price</h2>
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
    <th scope="row">Vendor Code</th>
    <td>
    <input type="text" id="vendercd" name="vendercd"  placeholder="" class="w100p" />
    </td>
    <th scope="row">Material Code</th>
    <td>
    <input type="text" id="mstcd" name="mstcd"  placeholder="" class="w100p" />
    </td>
     <th scope="row">Purchase ORG</th>
    <td>
    <select id="purchasorg" name="purchasorg" placeholder="" class="w100p" >
    <option value=""></option>
    <option value="2040">2040-Domestics</option>
    <option value="2041">2041-Import(EAST)</option>
    <option value="2042">2042-Import(WEST)</option>
    </select>
    </td> 
</tr>
<tr>
    <th scope="row">Material Type</th>
    <td>
    <select id="msttype" name="msttype"   title="" placeholder="" class="w100p" >
    </select>
    </td>
    <th scope="row">Exclude Delete</th>
    <td>
    <select id="excludedelete" name="excludedelete" placeholder="" class="w100p" >
<!--     <option value="Y" selected="selected">Y</option> -->
<!--     <option value="N">N</option> -->
    </select>
    </td>
    <td colspan="2"></td>
</tr>
</tbody>
</table><!-- table end -->


</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

 <ul class="right_btns">
    <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap" style="height:450px"></div>
</article><!-- grid_wrap end -->


</section><!-- search_result end -->


  <section class="tap_wrap"><!-- tap_wrap start -->
        <ul class="tap_type1">
            <li><a class="on" id="basic">Basic Info</a></li>
            <li><a  id="history">Purchase History</a></li>
        </ul>
        
        <article class="tap_area" id="tap_area_01" style="display: none;"><!-- tap_area start -->
            <table class="type1">
				<caption>search table</caption>
				<colgroup>
				    <col style="width:120px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				    <col style="width:120px" />
				    <col style="width:*" />
				</colgroup>
				<tbody>
				<tr> 
				    <th scope="row">Delete</th>
				    <td id="viewmarkdel"></td>
				    <td colspan="4"></td>
				</tr>
				<tr>
				    <th scope="row">Info Record No.</th>
				    <td id="viewinforcordno"></td>
				    <th scope="row">Purchase ORG</th>
				    <td id="viewpurchsorg"></td>   
                    <td colspan="2"></td>
         		 </tr>
				<tr>
				    <th scope="row">Vendor</th>
				    <td  id="viewvendor"></td>     
				    <th scope="row">Master Code</th>
				    <td id="viewmatrlmst"><input type="text" title="" placeholder=""  class="w100p" name="viewmatrlmst" readonly="readonly"/></td>     
				    <td colspan="2"  id="viewmatrltxt"></td>    
				</tr>
<!-- 				<tr> -->
<!-- 				    <th scope="row">Address</th> -->
<!-- 				    <td><input type="text" title="" placeholder=""  class="w100p" id="viewaddress" name="viewaddress" readonly="readonly"/></td> -->
<!-- 				    <th colspan="4"></th>   -->
<!-- 				</tr> -->
				<tr>
				    <th scope="row">Purchasing Group</th>
				    <td id="viewpurchsgrp"></td>
				    <th scope="row">Planned Delivery Time in Days</th>
				    <td id="viewplandelvrytmday"></td>
                    <td colspan="2"></td>
				</tr>
<!-- 				<tr> -->
<!-- 				    <th scope="row">E-Mail Address</th> -->
<!-- 				    <td><input type="text" title="" placeholder=""  class="w100p" id="viewemailaddress" name="viewemailaddress" readonly="readonly"/></td> -->
<!-- 				    <th colspan="4"></th>   -->
<!-- 				</tr> -->
				<tr>
				    <th scope="row">Tax Code</th>
				    <td id="viewtaxcode" colspan="2"></td>
<!-- 				    <th scope="row">Price Determination (Pricing) Date Control</th> -->
<!-- 				    <td><input type="text" title="" placeholder=""  class="w100p" id="viewprcdtermindtcntrl" name="viewprcdtermindtcntrl" readonly="readonly"/></td> -->
                        <td colspan="3"></td>
				</tr>
				<tr>
				    <th scope="row">Net Price</th>
				    <td>
				    <div class="itemPriceDate w100p">
			            <p  id="viewpurchsprc"></p>
			            <p class="short" id="viewcurname"></p>
			            <span>/</span>
			            <p class="short" id="viewcondiprcunit"></p>
			            <!-- <p class="short"><input type="text" title="" placeholder="" class="w100p" id="viewcondiunitname" name="viewcondiunitname" readonly="readonly" /></p> -->
			        </div>
				    </td>
				    <th scope="row">Validity end date</th>
				    <td id="viewvalidenddt"><input type="text" title="" placeholder=""  class="w100p" name="viewvalidenddt" readonly="readonly"/></td>
				    <td colspan="2"></td>
				    
				</tr>
<!-- 				<tr> -->
<!-- 				    <th scope="row">Transfer Cost</th> -->
<!-- 				    <td><input type="text"  title="" placeholder=""  class="w100p" id="viewtrnscost" name="viewtrnscost" readonly="readonly"/></td>      -->
<!-- 				    <th scope="row">Customs Cost</th> -->
<!-- 				    <td><input type="text"  title="" placeholder=""  class="w100p" id="viewcstmcost" name="viewcstmcost" readonly="readonly"/></td>      -->
<!-- 				    <th scope="row">Other Import Cost</th> -->
<!-- 				    <td><input type="text"  title="" placeholder=""  class="w100p" id="viewotherimprtcost" name="viewotherimprtcost" readonly="readonly"/></td>      -->
<!-- 				</tr> -->
                 
				</tbody>
				</table>
        
        </article><!-- tap_area end -->
            
        <article class="tap_area"><!-- tap_area start -->
            <article class="grid_wrap"><!-- grid_wrap start -->
                 <div id="history_grid"  class="mt10" ></div>
            </article><!-- grid_wrap end -->
        </article><!-- tap_area end -->
        
    </section>
</section><!-- content end -->
</div>




