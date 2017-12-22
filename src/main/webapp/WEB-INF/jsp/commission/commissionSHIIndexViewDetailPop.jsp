<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">
</style>

<script type="text/javaScript">
	var detailGridID;
	var today = "${today}";
	
	$(document).ready(function() {
		createAUIGrid();
		
		$("#searchD").click(function(){
			Common.ajax("GET", "/commission/report/commSHIDetailSearch", $("#detailFrom").serializeJSON(), function(result) {
				AUIGrid.setGridData(detailGridID, result);
			});
		});
		
		$("#excel").click(function(){
			var date =$("#searchDtD").val();
            var month = Number(date.substring(0, 2));
            var year = Number(date.substring(3));
            var memCd = $("#memberCd").val();
            
            var reportFileName = "/commission/SHIIndexExcelRawByMember.rpt"; //reportFileName
            var reportDownFileName = "SHIIndexExcelFile_" + today; //report name     
            var reportViewType = "EXCEL"; //viewType
            
            $("#reportForm2 #memberCode").val(memCd);
            $("#reportForm2 #pvMonth").val(month);
            $("#reportForm2 #pvYear").val(year);
            $("#reportForm2 #reportFileName").val(reportFileName);
            $("#reportForm2 #reportDownFileName").val(reportDownFileName);
            $("#reportForm2 #viewType").val(reportViewType);
            
        //  report 호출
            var option = {
                isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
            };
            Common.report("reportForm2", option);
		});
	});
	
	function createAUIGrid() {
        var columnLayout = [ {
            dataField : "accdebtyear",
            headerText : "RCM Year",
            style : "my-column",
            editable : false
        },{
            dataField : "accdebtmonth",
            headerText : "RCM Month",
            style : "my-column",
            editable : false
        },{
            dataField : "orderno",
            headerText : "Order No",
            style : "my-column",
            editable : false
        },{
            dataField : "custname",
            headerText : "Customer Name",
            style : "my-column",
            width:300,
            editable : false
        },{
            dataField : "targetamount",
            headerText : "Collection Target",
            style : "my-column",
            editable : false
        },{
            dataField : "collectedamount",
            headerText : "Current Collection",
            style : "my-column",
            editable : false
        },{
            dataField : "collectionrate",
            headerText : "Collection Rate",
            style : "my-column",
            editable : false
        },{
            dataField : "susTet",
            headerText : "TER/SUS",
            style : "my-column",
            editable : false
        }];
        // 그리드 속성 설정
        var gridPros = {
            
            // 페이징 사용       
            usePaging : true,
            // 한 화면에 출력되는 행 개수 20(기본값:20)
            pageRowCount : 20,
            // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
            skipReadonlyColumns : true,
            // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
            wrapSelectionMove : true,
            // 줄번호 칼럼 렌더러 출력
            showRowNumColumn : true
            
        };
        
        detailGridID = AUIGrid.create("#grid_wrap2", columnLayout,gridPros);
   }
</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1> <spring:message code='commission.title.pop.head.SHI'/></h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#"><spring:message code='sys.btn.close'/></a></p></li>
        </ul>
    </header><!-- pop_header end -->
    
    <section class="pop_body" style="max-height:600px;"><!-- pop_body start -->
       <aside class="title_line"><!-- title_line start -->
          <h2> <spring:message code='commission.title.pop.body.SHI'/><br>
          </h2>
        </aside><!-- title_line end -->
        
        <form name="reportForm2" id="reportForm2">
           <input type="hidden" name="V_MEMCODE" id="memberCode"/>
           <input type="hidden" name="V_PVMTH" id="pvMonth"/>
           <input type="hidden" name="V_PVYEAR" id="pvYear"/>
           <input type="hidden" name="reportDownFileName" id="reportDownFileName"/>
           <input type="hidden" name="reportFileName" id="reportFileName"/>
           <input type="hidden" name="viewType" id="viewType"/>
       </form>
        <form id="detailFrom">
           
           <ul class="right_btns">
              <li><p class="btn_blue"><a href="#" id="searchD"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
              <li><p class="btn_blue"><a href="javascript:fn_downFile()" id="excel"><spring:message code='commission.button.generate'/></a></p></li>
            </ul>
    
            <table class="type1 mt10"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.memCode'/></th>
                        <td>
                        <input type="text" id="memberCd" name="memberCd" value="${memCode }" readonly="readonly" >
                        </td>
                    </tr>
                    <tr>
                        <th scope="row"><spring:message code='commission.text.search.rcmMonth'/></th>
                         <td>
                         <input type="text" title="Create start Date" placeholder="MM/YYYY" name="searchDt" id="searchDtD" class="j_date2" value="${searchDtD }" />
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    
        <article class="grid_wrap3">
            <!-- grid_wrap start -->
            <div id="grid_wrap2" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section>
    
</div>
