<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
    background:#fff;
}
/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-right{
    text-align:right;
    background:#fff;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
/*     background:#D9E5FF; */
/*     color:#000; */
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
/*     background:#D9E5FF; */
/*     color:#000; */
}

</style>
<style type="text/css">

    /* 커스텀 셀 스타일 */
    .my-min-style {
        background:#fff;
    }

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
    var myGridID;
    var materialGrid;
    var filterGrid;
    var spareGrid;

    var isMerged = true; // 최초에는 merged 상태
    var selectedItem;

    // AUIGrid 칼럼 설정             // formatString : "mm/dd/yyyy",    dataType:"numeric", formatString : "#,##0"
     var columnLayout = [
								//{dataField:   "bom",headerText :"<spring:message code='log.head.materialcdoe'/>"  ,width: "10%"   , cellMerge : true,visible:true},
								{dataField: "bom",headerText :"<spring:message code='log.head.materialcode'/>"  ,width:100,style:"my-min-style"    ,visible:false},
								{dataField: "altrtivBom" ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
								//{dataField:   "plant",headerText :"<spring:message code='log.head.materialcodename'/>"    ,width: "10%"   ,visible:true,style :"aui-grid-user-custom-left"
								{dataField: "matrlNo",headerText :"<spring:message code='log.head.materialcode'/>"  ,width: "10%"   ,style:"my-min-style"    ,visible:true, cellMerge : true},
								{dataField: "stkdesc",headerText :"<spring:message code='log.head.materialname'/>"  ,width: "10%"   ,style:"my-min-style"    ,visible:true, cellMerge : true},
								{dataField: "matrlNm",headerText :"<spring:message code='log.head.materialcategory'/>"  ,width: "10%"   ,visible:true,
								    style :"aui-grid-user-custom-left",
		                            cellMerge : true,
		                            mergeRef : "matrlNo", // 이전 칼럼(대분류) 셀머지의 값을 비교해서 실행함. (mergePolicy : "restrict" 설정 필수)
		                            mergePolicy : "restrict"},
	                            {dataField: "",headerText :"<spring:message code='log.head.baseqty'/>"  ,width: "5%"    ,style:"my-min-style"    ,visible:false},
	                            {dataField: "bomUse" ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "bomItmNodeNo",headerText :"<spring:message code='log.head.componentno'/>"  ,width: "3%"    ,visible:true,style :"aui-grid-user-custom-right"  },
	                            {dataField: "bomCtgry"   ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "intnlCntr"  ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "itmCtgry"   ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "bomItmNo"   ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "sortString" ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "bomCompnt",headerText :"<spring:message code='log.head.component'/>"   ,width: "10%"   ,style:"my-min-style"    ,visible:true},
	                            {dataField: "stkDesc",headerText :"<spring:message code='log.head.componentname'/>" ,width: "28%"   ,visible:true,style :"aui-grid-user-custom-left"   },
	                            {dataField: "categoryid" ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "category",headerText :"<spring:message code='log.head.category'/>" ,width: "7%"    ,visible:true,style :"aui-grid-user-custom-left"   },
	                            {dataField: "compntQty",headerText :"<spring:message code='log.head.qty'/>" ,width: "5%"    ,visible:true,style :"aui-grid-user-custom-right"  },
	                            {dataField: "compntUnitOfMeasure"    ,headerText:    ""    ,width:100 ,style:"my-min-style"    ,visible:false},
	                            {dataField: "validFromDt",headerText :"<spring:message code='log.head.validfrom'/>" ,width: "8%"    ,style:"my-min-style"    ,visible:true},
	                            {dataField: "validToDt",headerText :"<spring:message code='log.head.validto'/>" ,width: "8%"    ,style:"my-min-style"    ,visible:true},
	                            {dataField: "leadTmOffset"   ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:true},
	                            {dataField: "alterItmGrp",headerText :"<spring:message code='log.head.alternativeitembygroup'/>"    ,width:100,style:"my-min-style"    ,visible:true},
	                            {dataField: "alterItmRankOrd",headerText :"<spring:message code='log.head.priorityofalternativeitem'/>" ,width:100,style:"my-min-style"    ,visible:true},
	                            {dataField: "useProbabiltiy",headerText :"<spring:message code='log.head.useprobabiltiy'/>" ,width:100,style:"my-min-style"    ,visible:true},
	                            {dataField: "chngNo" ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "delIndict"  ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "dtRcordCrtOn"   ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "userWhoCrtRcord"    ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "chngOn" ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "namePersonWhoChgObj"    ,headerText:    ""  ,width:100,style:"my-min-style"    ,visible:false},
	                            {dataField: "defaultFilter"    ,headerText:    "Filter Option"  ,width:100,style:"my-min-style" }
                         ];


    var gridoptions = {
    		showStateColumn : true ,
    		editable : true,
    		usePaging : false, /* NOTE: true 설정시 셀병합 실행 안됨*/
    		useGroupingPanel : false ,
    		fixedColumnCount:2,
    		   };


    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions); // 셀병합으로  안씀
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridoptions);
        //doGetComboCDC('/logistics/bom/selectCdcList', '' , '' , '','srchcdc', 'S', '');
        doGetCombo('/logistics/bom/selectCodeList', '15', '','srchcatagorytype', 'A' , '');

        AUIGrid.bind(myGridID, "cellClick", function( event )
        {
        	 f_removeclass();
        	 $("#subDiv").show();
        	 $("#material_info").click();
       		 $("#filter_info").show();
             $("#spare_info").show();

        });

        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event)
        {
        });

        AUIGrid.bind(myGridID, "cellEditBegin", function(event)
        {
        	return false;
        });

        AUIGrid.bind(myGridID, "ready", function(event) {
        });
        $("#subDiv").hide();
    });
    function filterAUIGrid(columnLayout) {
        filterGrid = AUIGrid.create("#filter_grid", columnLayout, gridoptions);
        AUIGrid.bind(filterGrid, "cellEditBegin", function(event)
        {
        	if (event.dataField == "leadTmOffset"){
        		return true;
        	}else{
        		return false;
        	}
        });
    }

    function spareAUIGrid(columnLayout) {
        spareGrid = AUIGrid.create("#spare_grid", columnLayout, gridoptions);
        AUIGrid.bind(spareGrid, "cellEditBegin", function(event)
        {
            return false;
        });
    }

    $(function(){
        $("#search").click(function(){
            searchAjax();
        });
        $("#clear").click(function(){
            $("#srchmtrcd").val('');
            doGetCombo('/logistics/bom/selectCodeList', '15', '','srchcatagorytype', 'A' , '');
            $("#srchValid").val('');
        });
        $("#download").click(function() {
            GridCommon.exportTo("grid_wrap", 'xlsx', "BOM List");
        });
       $("#material_info").click(function(){
               f_removeclass();

               var selectedItem = AUIGrid.getSelectedIndex(myGridID);
               var bom = AUIGrid.getCellValue(myGridID ,selectedItem[0],'bom');

    	        //alert(bom);

                 f_view("/logistics/bom/materialInfo.do?bom="+bom, "S");

                $("#material_info_div").show();

            $(this).find("a").attr("class","on");

        });
       $("#filter_info").click(function(){

              f_removeclass();

              var selectedItem = AUIGrid.getSelectedIndex(myGridID);
              var bom = AUIGrid.getCellValue(myGridID ,selectedItem[0],'bom');

              //alert(bom);

               f_view("/logistics/bom/filterInfo.do?bom="+bom+"&categoryid=62", "F");

               $("#filter_info_div").show();

           $(this).find("a").attr("class","on");

       });

       $("#spare_info").click(function(){

              f_removeclass();

              var selectedItem = AUIGrid.getSelectedIndex(myGridID);
              var bom = AUIGrid.getCellValue(myGridID ,selectedItem[0],'bom');

              //alert(bom);

               f_view("/logistics/bom/spareInfo.do?bom="+bom+"&categoryid=63", "R");

               $("#spare_info_div").show();

           $(this).find("a").attr("class","on");

       });
       $("#filterSave").click(function(){
    	   console.log(GridCommon.getEditData(filterGrid));
    	   Common.ajax("POST", "/logistics/bom/modifyLeadTmOffset.do", GridCommon.getEditData(filterGrid), function(result) {
               Common.alert(result.message);
               AUIGrid.resetUpdatedItems(myGridID, "all");

           },  function(jqXHR, textStatus, errorThrown) {
               try {
               } catch (e) {
               }

               Common.alert("Fail : " + jqXHR.responseJSON.message);
           });
       });
       $("#print").click(function(){
//            $("#srchmtrcd").val('');
//            doGetCombo('/logistics/bom/selectCodeList', '15', '','srchcatagorytype', 'A' , '');
//            $("#srchValid").val('');
    	   var selected = AUIGrid.getSelectedItems(myGridID);
    	   if (selected.length){
    		   Common.alert('Please selected Data');
    	   }else{
	    	   console.log(selected[0].item);
	    	   var itm = selected[0].item;
	    	   console.log(itm);
	    	   $("#V_BOM").val(itm.bom);

	    	   Common.report("printForm");
    	   }
       });

       $("#srchmtrcd").keypress(function(event) {
           if (event.which == '13') {
               $("#svalue").val($("#srchmtrcd").val());
               $("#sUrl").val("/logistics/material/materialcdsearch.do");
               Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");
           }
       });

       $("#srchmtrcd").dblclick(function() {

               $("#svalue").val($("#srchmtrcd").val());
               $("#sUrl").val("/logistics/material/materialcdsearch.do");
               Common.searchpopupWin("searchForm", "/common/searchPopList.do","stock");

       });


    });

    function fn_itempopList(data){
        console.log(data);
        $("#srchmtrcd").val(data[0].item.itemcode);
    }

    /* function Start*/
   function doGetComboCDC(url, groupCd ,codevalue ,  selCode, obj , type, callbackFn){

    	$.ajax({
    		  type : "GET",
    	        url : url,
    	        data :{ groupCode : groupCd , codevalue : codevalue},
    	        dataType : "json",
    	        contentType : "application/json;charset=UTF-8",
    	        success : function(data) {

    	           var rData = data;
    	           doDefCombo(rData, selCode, obj , type,  callbackFn);
    	        },
    	        error: function(jqXHR, textStatus, errorThrown){
    	            alert("Draw ComboBox['"+obj+"'] is failed. \n\n Please try again.");
    	        },
    	        complete: function(){
    	        }
    	});
    }


   function searchAjax() {
        var url = "/logistics/bom/selectBomList.do";
        var param = $('#searchForm').serializeJSON();
        console.log(param);
        Common.ajax("POST" , url , param , function(data){
            AUIGrid.setGridData(myGridID, data.data);
            $("#subDiv").hide();
        });
    }


   function setCellMerge() {
           //isMerged = !isMerged;
           AUIGrid.setCellMerge(myGridID, isMerged);
   }

   function f_removeclass(){
       var lisize = $("#subDiv > ul > li").size();
       for (var i = 0 ; i < lisize ; i++){
           $("#subDiv > ul > li").eq(i).find("a").removeAttr("class");
       }

       var r = $("#subDiv > .tap_area").size();
       for(var i = 0 ; i < r ; i++){
           $("#subDiv > .tap_area").eq(i).hide();
       }

   }

   function f_view(url, v) {
       $.ajax({
           type : "POST",
           url : url,
           dataType : "json",
           contentType : "application/json;charset=UTF-8",
           success : function(_data) {
               var data = _data.data;

               f_info(data, v);
           },
           error : function(jqXHR, textStatus, errorThrown) {
               alert("실패하였습니다.");
           }
       });
   }


   function f_info(data, v) {
	   if (v == 'S') {
           $("#txtStockType").empty();
           $("#txtStockCode").empty();
           $("#txtUOM").empty();

           $("#txtStockName").empty();
           $("#txtCategory").empty();

           $("#txtNetWeight").empty();
           $("#txtMeasurement").empty();

           //$("#txtStockType").text(data[0].stkCtgryID);
           $("#txtStockType").text(data[0].stkTypeNm);
           $("#txtStatus").text(data[0].stusCodeNm);
           $("#txtStockCode").text(data[0].matrlNo);
           $("#txtUOM").text(data[0].uomName);
           $("#txtStockName").text(data[0].stkDesc);
           $("#txtCategory").text(data[0].stkCtgryNm );
           $("#txtNetWeight").text(data[0].netWt);
           $("#txtGrossWeight").text(data[0].grosWt);
           $("#txtMeasurement").text(data[0].measureCbm);

           if (data[0].isNcv == 1) {
               $("#cbNCV").prop("checked", true);
           }
           if (data[0].isSirim == 1) {
               $("#cbSirim").prop("checked", true);
           }
           $("#cbNCV").prop("disabled", true);
           $("#cbSirim").prop("disabled", true);

           //$("#typeid").val(data[0].typeid);
       } else if (v == 'F') {
    	   AUIGrid.destroy(filterGrid);
           filterAUIGrid(columnLayout)
           AUIGrid.setGridData(filterGrid, data);
           //colShowHide(filterGrid,"",false);

       } else if (v == 'R') {
    	   AUIGrid.destroy(spareGrid);
           spareAUIGrid(columnLayout);
           AUIGrid.setGridData(spareGrid, data);
           //colShowHide(spareGrid,"",false);

       }
   }

   function colShowHide(gridNm,fied,checked){
       if(checked) {
             AUIGrid.showColumnByDataField(gridNm, fied);
         } else {
             AUIGrid.hideColumnByDataField(gridNm, fied);
         }
 }

   function f_multiCombo() {
	    $(function() {
	        $('#catagorytype').change(function() {
	        }).multipleSelect({
	            selectAll : true
	        });
	    });
	}

</script>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
	<section id="content">
		<!-- content start -->
		<ul class="path">
			<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif"
				alt="Home" /></li>
			<li>BOM</li>
		</ul>
         <!-- title_line start -->
		<aside class="title_line">
			<p class="fav">
				<a href="#" class="click_add_on">My menu</a>
			</p>
			<h2>BOM</h2>
			<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
				<li><p class="btn_blue">
						<a id="search"><span class="search"></span>
						<spring:message code='sys.btn.search' /></a>
					</p></li>
</c:if>
				<li><p class="btn_blue">
						<a id="clear"><span class="clear"></span>
						<spring:message code='sys.btn.clear' /></a>
					</p></li>
				<li><p class="btn_blue">
                        <a id="print"><span class="clear"></span>
                        <spring:message code='sys.progmanagement.grid1.PRINT' /></a>
                    </p></li>
			</ul>
		</aside>
		<!-- title_line end -->


			<!-- search_table start -->
		<section class="search_table">
			<form id="searchForm" name="searchForm">
			    <input type="hidden" id="svalue" name="svalue"/>
                <input type="hidden" id="sUrl"   name="sUrl"  />
				<table class="type1">
					<!-- table start -->
					<caption>table</caption>
					<colgroup>
						<col style="width: 150px" />
						<col style="width: *" />
						<col style="width: 160px" />
						<col style="width: *" />
						<col style="width: 160px" />
						<col style="width: *" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">Material Code</th>
							<td>
								<input id="srchmtrcd" name="srchmtrcd" type="text" title=""  class="w100p" />
								<!-- date_set end -->
							</td>
						    <th scope="row">Category Type</th>
						    <td>
						    <select  id="srchcatagorytype" name="srchcatagorytype" class="w100p" /></select>
						    <!-- <select class="multy_select" multiple="multiple" id="catagorytype" name="catagorytype[]" /></select> -->
						    </td>
<!-- 							<th scope="row">CDC</th>
							<td><select class="w100p" id="srchcdc" name="srchcdc">
							</td> -->
							<th scope="row">Valid From Date</th>
							<td>
										<input type="text" title="Create start Date"
											class="j_date w100p" id="srchValid" name="srchValid" placeholder="DD/MM/YYYY"/>
						</td>
						</tr>
					</tbody>
				</table>
				<!-- table end -->
			</form>
		</section>
		<section class="search_result">
		<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
            <li><p class="btn_grid"><a id="download"><spring:message code='sys.btn.excel.dw' /></a></p></li>
</c:if>
        </ul>
			<article class="grid_wrap">
				<!-- grid_wrap start -->
				<div id="grid_wrap" style="height:500px"></div>
			</article>
			    <!--<section id="subDiv" style="display:none;" class="tap_wrap"> tap_wrap start -->
			    <section id="subDiv"class="tap_wrap"><!-- tap_wrap start -->

            <ul class="tap_type1">
                <li id="material_info"><a href="#"> Material Code Info </a></li>
                <li id="filter_info"><a href="#"> Filter Info</a></li>
                <li id="spare_info"><a href="#"> Spare Part Info</a></li>
            </ul>
            <article class="tap_area" id="material_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                <!-- <h3>Material Code Info</h3> -->
             <!--    <ul class="left_opt">
                    <li><p class="btn_blue"><a id="material_info_edit">EDIT</a></p></li>
                </ul> -->
                </aside>
                <form id="materialInfo" name="materialInfo" method="post">
                <table class="type1">
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
                        <th scope="row">Stock Type</th>
                        <td ID="txtStockType"></td>
                        <th scope="row">Status</th>
                        <td ID="txtStatus"></td>
                        <td colspan="2">
                            <label><input type="checkbox" id="cbSirim"/><span>Sirim Certificate</span></label>
                            <label><input type="checkbox" id="cbNCV" /><span>NCV</span></label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Stock Code</th>
                        <td ID="txtStockCode"></td>
                        <th scope="row">UOM</th>
                        <td colspan="3" id="txtUOM"></td>
                    </tr>
                    <tr>
                        <th scope="row">Stock Name</th>
                        <td colspan="3" id="txtStockName"></td>
                        <th scope="row">Category</th>
                        <td ID="txtCategory"></td>
                    </tr>
                    <tr>
                        <th scope="row">Net Weight (KG)</th>
                        <td ID="txtNetWeight"></td>
                        <th scope="row">Gross Weight (KG)</th>
                        <td ID="txtGrossWeight"></td>

                        <th scope="row">Measurement CBM</th>
                        <td ID="txtMeasurement"></td>
                    </tr>
                    </tbody>
                </table>
                </form>
            </article>
            <article class="tap_area" id="filter_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                    <!-- <h3 id="filterTab">Filter Info</h3> -->
                    <!-- <ul class="left_opt">
                    <li><p class="btn_blue"><a id="filter_info_edit">EDIT</a></p></li>
                    </ul> -->
                </aside>
                <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
		            <li><p class="btn_grid"><a id="filterSave">SAVE</a></p></li>
</c:if>
		        </ul>
                <div id="filter_grid" style="width:100%;">
                </div>
            </article>
            <article class="tap_area" id="spare_info_div" style="display:none;">
                <aside class="title_line"><!-- title_line start -->
                    <!-- <h3> Spare Part List</h3> -->
                    <!-- <ul class="left_opt">
                    <li><p class="btn_blue"><a id="spare_info_edit">EDIT</a></p></li>
                    </ul> -->
                </aside>
                <div id="spare_grid" style="width:100%;"></div>
            </article>
        </section><!--  tab -->
			<!-- grid_wrap end -->
		</section>
	</section>
	<form id="printForm" name="printForm">
	   <input type="hidden" id="viewType" name="viewType" value="WINDOW" />
	   <input type="hidden" id="V_BOM" name="V_BOM" value="" />
	   <input type="hidden" id="reportFileName" name="reportFileName" value="/logistics/STOCK_BOM_LISTING.rpt" /><br />
	</form>
</div>
