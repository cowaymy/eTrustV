<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">
/* 커스텀 칼럼 스타일 정의 */
.right-column {
    text-align:right;
    margin-top:-20px;
}
</style>
<script type="text/javaScript">
var myGridID;
var memCode;
var today = "${today}";
	$(document).ready(function() {
		createAUIGrid();
		AUIGrid.setSelectionMode(myGridID, "singleRow");
		
		$("#search").click(function(){
			var valid = $("#memCode").val();
			
			if(valid == null || valid == ""){
				//Common.alert("Please select the member code");
				Common.setMsg("<spring:message code='commission.alert.SHIIndex.member.noSelect'/>");
				$("#teamCode").val("");
                $("#level").val("");
			}else{
				Common.ajax("GET", "/commission/report/commSHIMemSearch", $("#myForm").serializeJSON(), function(result) {
					if(result != null){
						$("#teamCode").val(result.DEPT_CODE);
						$("#level").val(result.MEM_LVL);
						
						
						Common.ajax("GET", "/commission/report/commSPCRgenrawSHIIndex", $("#myForm").serializeJSON(), function(result) {
							AUIGrid.setGridData(myGridID, result);
						});
					}else{
						//Common.alert("No member record found");
						Common.setMsg("<spring:message code='commission.alert.SHIIndex.member.noFound'/>");
						$("#memCode").val("");
						$("#teamCode").val("");
						$("#level").val("");
					}
				});
			}
		});
		
		$('#memBtn').click(function() {
		    //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
		    Common.popupDiv("/common/memberPop.do", $("#myForm").serializeJSON(), null, true);
		});
		
		AUIGrid.bind(myGridID, "cellClick", function(event) {
			memCode = null;
			if(AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode") != null && AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode") != ""){
				memCode = AUIGrid.getCellValue(myGridID, event.rowIndex, "memCode");
				var date ={"memCode" : memCode, "searchDt" : $("#shiDate").val()};
				Common.popupDiv("/commission/report/commSHIIndexViewDetailsPop.do",date);
			}
		});
		
		$("#clear").click(function(){
			document.myForm.reset();
		});
		
		$("#generate").click(function(){
		    var valid = $("#memCode").val();
            
            if(valid == null || valid == ""){
                //Common.alert("Please select the member code");
            	Common.setMsg("<spring:message code='commission.alert.SHIIndex.member.noSelect'/>");
            }else{
            	var date =$("#shiDate").val();
                var month = Number(date.substring(0, 2));
                if(month < 10){
                    month = "0"+month;
                }
                var year = Number(date.substring(3));
                var memCd = $("#memCode").val();
                var typeCode = $("#typeCode").val();
                var teamCode = $("#teamCode").val();
                var level = $("#level").val();
                
                var reportFileName = "/commission/SHIIndexExcelRaw.rpt"; //reportFileName
                var reportDownFileName = "SHIIndexExcelFile_" + today; //report name     
                var reportViewType = "EXCEL"; //viewType
                    
                $("#reportForm #mCode").val(memCd);
                $("#reportForm #month").val(month);
                $("#reportForm #year").val(year);
                $("#reportForm #mLvl").val(level);
                $("#reportForm #mType").val(typeCode);
                $("#reportForm #deptCode").val(teamCode);
                
                $("#reportForm #reportFileName").val(reportFileName);
                $("#reportForm #reportDownFileName").val(reportDownFileName);
                $("#reportForm #viewType").val(reportViewType);
                
            //  report 호출
                var option = {
                    isProcedure : true, // procedure 로 구성된 리포트 인경우 필수.
                };
                Common.report("reportForm", option);
            }
		});
	});
	
	function createAUIGrid() {
	    var columnLayout3 = [{
	        dataField : "topOrgCode",
	        headerText : "Top Org Code",
	        editable : false
	    },{
	        dataField : "orgCode",
	        headerText : "Org Code",
	        editable : false
	    },{
	        dataField : "grpCode",
	        headerText : "Grp Code",
	        editable : false
	    },{
	        dataField : "deptCode",
	        headerText : "Dept Code",
	        editable : false
	    },{
	        dataField : "memCode",
	        headerText : "Member Code",
	        editable : false
	    },{
	        dataField : "unit",
	        headerText : "Unit",
	        style : "right-column",
	        editable : false
	    },{
	        dataField : "targetatmt",
	        headerText : "Target",
	        style : "right-column",
	        editable : false
	    },{
	        dataField : "collectamt",
	        headerText : "Current Collection",
	        style : "right-column",
	        editable : false
	    },{
	        dataField : "collectrate",
	        headerText : "Collection Rate",
	        style : "right-column",
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
	        showRowNumColumn : true,
	        
	        headerHeight : 40
	    };
	    myGridID = AUIGrid.create("#grid_wrap", columnLayout3,gridPros);
	   }
	
	function fn_loadOrderSalesman(memId, memCode) {
	    $("#memCode").val(memCode);
	    console.log(' memId:'+memId);
	    console.log(' memCd:'+memCode);
	}
</script>

<section id="content"><!-- content start -->
	<ul class="path">
		<li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
		<li><spring:message code='commission.text.head.commission'/></li>
		<li><spring:message code='commission.text.head.report'/></li>
		<li><spring:message code='commission.text.head.shiIndex'/></li>
	</ul>
	
	<aside class="title_line"><!-- title_line start -->
		<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
		<h2><spring:message code='commission.title.SHI'/></h2>
		<ul class="right_btns">
			<li><p class="btn_blue"><a href="#" id="search"><spring:message code='sys.btn.search'/></a></p></li>
			<li><p class="btn_blue"><a href="#" id="clear"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
		</ul>
	</aside><!-- title_line end -->
	
	
	<section class="search_table"><!-- search_table start -->
	   <form name="reportForm" id="reportForm">
	       <input type="hidden" name="V_MEMCODE" id="mCode"/>
	       <input type="hidden" name="V_PVMTH" id="month"/>
	       <input type="hidden" name="V_PVYEAR" id="year"/>
	       <input type="hidden" name="V_MEMLVL" id="mLvl"/>
	       <input type="hidden" name="V_MEMTYPE" id="mType"/>
	       <input type="hidden" name="V_DEPTCODE" id="deptCode"/>
	       <input type="hidden" name="reportDownFileName" id="reportDownFileName"/>
	       <input type="hidden" name="reportFileName" id="reportFileName"/>
	       <input type="hidden" name="viewType" id="viewType"/>
	   </form>
		<form action="#" method="post" name="myForm" id="myForm">
			
			<table class="type1"><!-- table start -->
				<caption>table</caption>
				<colgroup>
					<col style="width:140px" />
					<col style="width:*" />
					<col style="width:140px" />
					<col style="width:*" />
					<col style="width:170px" />
					<col style="width:*" />
				</colgroup>
				<tbody>
					<tr>
						<th scope="row"><spring:message code='commission.text.search.orgType'/></th>
						<td>
							<select class="w100p" id="typeCode" name="typeCode">
							<c:forEach var="list" items="${memType }">
                                    <option value="${list.cdid}">${list.cdnm} (${list.cd})</option>
                                </c:forEach>
							</select>
						</td>
						<th scope="row"><spring:message code='commission.text.search.memCode'/></th>
						<td>
						  <input type="text" title="" placeholder="" id="memCode" name="memCode"/>
						  <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
						</td>
						<th scope="row"><spring:message code='commission.text.search.commMonth'/></th>
						<td>
						  <input type="text" title="기준년월" class="j_date2 w100p" id="shiDate" name="shiDate" value="${searchDt }" />
						</td>
					</tr>
					<tr>
						<th scope="row">* <spring:message code='commission.text.search.teamCode'/></th>
						<td>
						  <input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly"  id="teamCode" name="teamCode"/>
						</td>
						<th scope="row">* <spring:message code='commission.text.search.level'/></th>
						<td colspan="3">
						  <input type="text" title="" placeholder="" class="w100p readonly" readonly="readonly" readonly="readonly"  id="level" name="level"/>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="col_all">
						  <p><span><spring:message code='commission.text.selectMonth'/></span></p>
						</td>
					</tr>
					<tr>
						<td colspan="6" class="col_all al_center">
						
							<table class="type2" style="width:460px;"><!-- table start -->
								<caption>table</caption>
								<colgroup>
									<col style="width:340px" />
									<col style="width:120px" />
								</colgroup>
								<thead>
									<tr>
										<th scope="col" class="al_center">RC Rate</th>
										<th scope="col" class="al_center">SHI Index</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="al_center"><span>90% ~ 100% Excellent</span></td>
										<td class="al_center"><span>10%</span></td>
									</tr>
									<tr>
									   <td class="al_center"><span>80% ~ 89% Very Good (target average)</span></td>
										<td class="al_center"><span>5%</span></td>
									</tr>
									<tr>
										<td class="al_center"><span>70% ~ 79% Good (above average)</span></td>
										<td class="al_center"><span>0%</span></td>
									</tr>
									<tr>
										<td class="al_center"><span>60% ~ 69% Poor (below average)</span></td>
										<td class="al_center"><span>-10%</span></td>
									</tr>
									<tr>
										<td class="al_center"><span>50% ~ 59% (serious)</span></td>
										<td class="al_center"><span>-20%</span></td>
									</tr>
									<tr>
										<td class="al_center"><span>0% ~ 49% (Worst)</span></td>
										<td class="al_center"><span>-30%</span></td>
									</tr>
								</tbody>
							</table><!-- table end -->
						
						</td>
					</tr>
				</tbody>
			</table><!-- table end -->
		</form>
	</section><!-- search_table end -->
	
	<section class="search_result"><!-- search_result start -->
	
	<ul class="right_btns">
		<li><p class="btn_grid"><a href="#" id="generate"><spring:message code='sys.btn.excel.dw' /></a></p></li>
	</ul>
	
	<article class="grid_wrap"><!-- grid_wrap start -->
	<div id="grid_wrap" style="width: 100%; height: 334px; margin: 0 auto;"></div>
	</article><!-- grid_wrap end -->
	
	</section><!-- search_result end -->

</section><!-- content end -->

		
<hr />

</body>
</html>