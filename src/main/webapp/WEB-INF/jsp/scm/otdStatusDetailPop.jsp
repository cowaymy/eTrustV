<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
/* 칼럼 스타일 전체 재정의 */
.aui-grid-left-column {
	text-align:left;
}
</style>

<script type="text/javaScript">
var soGIGridID, soPPGridID, gridOptions, otdSOGILayout, otdSOPPLayout;

function fnSelectBoxChanged()
{
   $("#menuCdNm").val("");
   $("#menuCdNm").focus();
}

function fnClose()
{
	$("#otdDetailPop").remove();
}

function fnDetailTabClick(flag)
{
	fnSelectOTDDetailPopData(flag);
}

function fnSelectOTDDetailPopData(flag)
{
	 $("#detailGbn").val(flag);
	 console.log("tabClick_detailGbn: " + $("#detailGbn").val() );

	 Common.ajax("GET"
	           , "/scm/selectOtdSODetailPop.do"
	           , $("#MainForm").serialize()
	           , function(result)
	             {
	        	      if ( $("#detailGbn").val() =="GI")
	            	  {
	                /********************************
                          soGI GRID
                  *********************************/

	        	    	  if(AUIGrid.isCreated(soGIGridID))
                       AUIGrid.destroy(soGIGridID);

                    if(AUIGrid.isCreated(soPPGridID))
                       AUIGrid.destroy(soPPGridID);


                    gridOptions = {
                    		            usePaging : false,
				                            useGroupingPanel : false,
				                            editable : false,
				                            showRowNumColumn : false,  // 그리드 넘버링
				                            // 그룹핑 후 셀 병함 실행
				                            enableCellMerge : true,
				                            // 그룹핑, 셀머지 사용 시 브랜치에 해당되는 행 표시 안함.
				                            showBranchOnGrouping : false,
				                            // 그룹핑 패널 사용
				                            useGroupingPanel : false,

				                            // 차례로 country, product, 순으로 그룹핑을 합니다.
				                            // 즉, 각 나라별, 각 제품으로 그룹핑
				                            groupingFields : ["poNo","stockCode","stockDesc","stockType","poQty"],
                                  };

                    otdSOGILayout =
                        [
                            {
                                dataField : "poNo",
                                headerText : "<spring:message code='sys.scm.otdview.PO' />",
                                width : "15%",
                            },{
                                dataField : "stockCode",
                                headerText : "<spring:message code='sys.scm.otdview.StkCode' />",
                                width : "10%",
                            },{
                                dataField : "stockDesc",
                                headerText : "<spring:message code='sys.scm.otdview.StkDesc' />",
                                width : "15%",
                            },{
                                dataField : "stockType",
                                headerText : "<spring:message code='sys.scm.inventory.stockType' />",
                                width : "7%",
                            },{
                                dataField : "poQty",
                                headerText :"<spring:message code='sys.scm.otdview.poQty' />",
                                width : "10%"
                            },{
                                dataField : "soQty",
                                headerText :"<spring:message code='sys.scm.otdview.soQty' />",
                                width : "10%"
                            },{
                                dataField : "giQty",
                                headerText :"<spring:message code='sys.scm.otdview.giQty' />",
                                width : "10%"
                            },{
                                dataField : "soDate",
                                headerText :"<spring:message code='sys.scm.otdview.soDate' />",
                                dataType : "date",
                                formatString : "dd-mm-yyyy",
                                width : "15%"
                            },{
                                dataField : "giDate",
                                headerText :"<spring:message code='sys.scm.otdview.giDate' />",
                                dataType : "date",
                                formatString : "dd-mm-yyyy",
                                width : "15%"
                            }
                        ];

                    // AUIGrid 그리드를 생성합니다.
                    soGIGridID = GridCommon.createAUIGrid("soGIGridDiv", otdSOGILayout,"", gridOptions);

                    // cellClick event.
                    AUIGrid.bind(soGIGridID, "cellClick", function( event )
                    {
                        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedParammenuId: " + $("#searchParamMenuId").val() +" / "+ $("#searchParammenuName").val());
                    });

                    // 셀 더블클릭 이벤트 바인딩
                    AUIGrid.bind(soGIGridID, "cellDoubleClick", function(event)
                    {
                        console.log("GI_DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
                    });

	        	    	  AUIGrid.setGridData(soGIGridID, result.selectOtdSOGIDetailPopList);
	          	    	console.log("성공 fnPopUpSOGIDetailPopList: " + result.selectOtdSOGIDetailPopList.length);
	                }
	        	      else
	            	  {
	                /********************************
                          soPP GRID
                  *********************************/
		                if(AUIGrid.isCreated(soGIGridID))
		                  AUIGrid.destroy(soGIGridID);

		                if(AUIGrid.isCreated(soPPGridID))
		                  AUIGrid.destroy(soPPGridID);


                    gridOptions = {
                                    usePaging : false,
                                    useGroupingPanel : false,
                                    editable : false,
                                    showRowNumColumn : false,  // 그리드 넘버링
                                    // 그룹핑 후 셀 병함 실행
                                    enableCellMerge : true,
                                    // 그룹핑, 셀머지 사용 시 브랜치에 해당되는 행 표시 안함.
                                    showBranchOnGrouping : false,
                                    // 그룹핑 패널 사용
                                    useGroupingPanel : false,

                                    // 차례로 country, product, 순으로 그룹핑을 합니다.
                                    // 즉, 각 나라별, 각 제품으로 그룹핑
                                    groupingFields : ["poNo","stockCode","stockDesc","stockType","poQty","soNo","soQty"],
                                  };

		                otdSOPPLayout =
		                      [
		                          {
		                              dataField : "poNo",
		                              headerText : "<spring:message code='sys.scm.otdview.PO' />",
		                              width : "10%",
		                          },{
		                              dataField : "stockCode",
		                              headerText : "<spring:message code='sys.scm.otdview.StkCode' />",
		                              width : "10%",
		                          },{
		                              dataField : "stockDesc",
		                              headerText : "<spring:message code='sys.scm.otdview.StkDesc' />",
		                              width : "15%",
		                          },{
		                                dataField : "stockType",
		                                headerText : "<spring:message code='sys.scm.inventory.stockType' />",
		                                width : "7%",
		                          },{
		                              dataField : "poQty",
		                              headerText :"<spring:message code='sys.scm.otdview.poQty' />",
		                              width : "10%",
		                          },{
		                              dataField : "soNo",
		                              headerText :"<spring:message code='sys.scm.otdview.soNo' />",
		                              width : "10%",
		                          },{
		                              dataField : "soQty",
		                              headerText :"<spring:message code='sys.scm.otdview.soQty' />",
		                              width : "10%",
		                          },{
		                              dataField : "planQty",
		                              headerText :"<spring:message code='sys.scm.otdview.planQty' />",
		                              width : "10%",
		                          },{
		                              dataField : "planDt",
		                              headerText :"<spring:message code='sys.scm.otdview.planDate' />",
		                              dataType : "date",
		                              formatString : "dd-mm-yyyy",
		                              width : "10%",
		                          },{
		                              dataField : "resultQty",
		                              headerText :"<spring:message code='sys.scm.otdview.resultQty' />",
		                              width : "10%",
		                          },{
		                              dataField : "resultDt",
		                              headerText :"<spring:message code='sys.scm.otdview.resultDate' />",
		                              dataType : "date",
		                              formatString : "dd-mm-yyyy",
		                              width : "10%",
		                          }
		                      ];

		                  // AUIGrid 그리드를 생성합니다.
		                    soPPGridID = GridCommon.createAUIGrid("soPPGridDiv", otdSOPPLayout,"", gridOptions);

		                    // cellClick event.
		                    AUIGrid.bind(soPPGridID, "cellClick", function( event )
		                    {
		                        console.log("CellClick rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clickedParammenuId: " + $("#searchParamMenuId").val() +" / "+ $("#searchParammenuName").val());
		                    });

		                 // 셀 더블클릭 이벤트 바인딩
		                    AUIGrid.bind(soPPGridID, "cellDoubleClick", function(event)
		                    {
		                        console.log("PP_DobleClick ( " + event.rowIndex + ", " + event.columnIndex + ") :  " + " value: " + event.value );
		                    });

			        	    	  AUIGrid.setGridData(soPPGridID, result.selectOtdSOPPDetailPopList);
			                  console.log("성공 fnPopUpSOPPDetailPopList: " + result.selectOtdSOPPDetailPopList.length);
		                }

	             }
	           , function(jqXHR, textStatus, errorThrown)
	             {
	               try
	               {
	                 console.log("Fail Status : " + jqXHR.status);
	                 console.log("code : "        + jqXHR.responseJSON.code);
	                 console.log("message : "     + jqXHR.responseJSON.message);
	                 console.log("detailMessage : "  + jqXHR.responseJSON.detailMessage);
	               }
	               catch (e)
	               {
	                 console.log(e);
	               }

	               Common.alert("Fail : " + jqXHR.responseJSON.message);
	             });

}


/***************************************************[ Main GRID] ***************************************************/

$(document).ready(function()
{
  // Call
  fnSelectOTDDetailPopData("GI");

});   //$(document).ready


</script>

<body>

<div id="popup_wrap" class="popup_wrap"><!-- popup_wrap start -->

	<header class="pop_header"><!-- pop_header start -->
		<h1>OTD</h1>
		<ul class="right_opt">
			<li><p class="btn_blue2"><a href="fnClose();">CLOSE</a></p></li>
		</ul>
	</header><!-- pop_header end -->

	<section class="pop_body"><!-- pop_body start -->
	<form id="PopForm" method="get" action="">

		<section class="tap_wrap mt0"><!-- tap_wrap start -->

			<ul class="tap_type1 num4">
				<li><a onclick="javascript:fnDetailTabClick('GI');" class="on">SO GI Details</a></li>
				<li><a onclick="javascript:fnDetailTabClick('PP');">SO PP Details</a></li>
			</ul>

			<article class="tap_area"><!-- tap_area start -->
				<article class="grid_wrap"><!-- grid_wrap start -->
				  <!-- 그리드 영역 1-->
				  <div id="soGIGridDiv"></div>
				</article><!-- grid_wrap end -->
			</article><!-- tap_area end -->

			<article class="tap_area"><!-- tap_area start -->
				<article class="grid_wrap"><!-- grid_wrap start -->
				  <!-- 그리드 영역 2-->
		  	  <div id="soPPGridDiv"></div>
				</article><!-- grid_wrap end -->
			</article><!-- tap_area end -->

		</section><!-- tap_wrap end -->

	</form>

	</section><!-- pop_body end -->

	</div><!-- popup_wrap end -->
</body>
</html>