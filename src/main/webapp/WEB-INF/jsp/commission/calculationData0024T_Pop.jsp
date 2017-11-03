<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.my-column {
    text-align: left;
    margin-top: -20px;
}
</style>

<script type="text/javaScript">
    var myGridID_24T;
    
    $(document).ready(function() {
        createAUIGrid();
        // cellClick event.
        AUIGrid.bind(myGridID_24T, "cellClick", function(event) {
              console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
        });
         
        //Rule Book Item search
        $("#search_24T").click(function(){ 
            Common.ajax("GET", "/commission/calculation/selectDataCMM024T", $("#form_24").serialize(), function(result) {
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myGridID_24T, result);
            });
        });
        
        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#form_24").serializeJSON(), null, true);
        });
        
    });
    
    function fn_loadOrderSalesman(memId, memCode) {
        $("#emplyCd_24T").val(memCode);
        console.log(' memId:'+memId);
        console.log(' memCd:'+memCode);
    }
    
   function createAUIGrid() {
	    var columnLayout3 = [ {
	        dataField : "emplyId",
	        headerText : "EMPLY ID",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "emplyCode",
	        headerText : "EMPLY CODE",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "prfomPrcnt",
	        headerText : "PRFOM PRCNT",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "prfomncRank",
	        headerText : "PRFOMNC RANK",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "totEmply",
	        headerText : "TOT EMPLY",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "cumltDstrib",
	        headerText : "CUMLT DSTRIB",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "payoutPrcnt",
	        headerText : "PAYOUT PRCNT",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "payoutAmt",
	        headerText : "PAYOUT AMT",
	        style : "my-column",
	        editable : false
	    },{
	        dataField : "taskId",
	        headerText : "TASK ID",
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
	    myGridID_24T = AUIGrid.create("#grid_wrap_24T", columnLayout3,gridPros);
   }
   
   function fn_downFile() {
	   Common.ajax("GET", "/commission/calculation/cntCMM0024T", $("#form_24").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
		       //excel down load name 형식 어떻게 할지?
		       var fileName = $("#fileName").val();
		       var searchDt = $("#CMM0024T_Dt").val();
		       var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		       var month = searchDt.substr(0,searchDt.indexOf("/"));
		       var code = $("#code_24T").val();
		       
		       var ordId = $("#ordId_24T").val();
		       var emplyCd = $("#emplyCd_24T").val();
		       var actionType = $("#actionType24T").val();
		       //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
		       //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
		       //window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&ordId="+ordId+"&emplyCd="+emplyCd+"'/>";
		       
		       Common.showLoader();
              $.fileDownload("/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&ordId="+ordId+"&emplyCd="+emplyCd +"&actionType="+actionType)
              .done(function () {
                  Common.alert('File download a success!');                
                  Common.removeLoader();            
              })
              .fail(function () {
                  Common.alert('File download failed!');                
                  Common.removeLoader();            
               });
	       }else{
	           Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>");
	       }
	   });
   }
   
   function fn_AlldownFile() {
	   var data = { "searchDt" : $("#CMM0024T_Dt").val() , "code": $("#code_24T").val()};
	   Common.ajax("GET", "/commission/calculation/cntCMM0024T", data, function(result) {
           var cnt = result;
           if(cnt > 0){
		      var fileName = $("#fileName").val();
		      var searchDt = $("#CMM0024T_Dt").val();
		      var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		      var month = searchDt.substr(0,searchDt.indexOf("/"));
		      var code = $("#code_24T").val();
		      var actionType = $("#actionType24T").val();
		      //window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"'/>";
		      
		      Common.showLoader();
              $.fileDownload("/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code +"&actionType="+actionType)
              .done(function () {
                  Common.alert('File download a success!');                
                  Common.removeLoader();            
              })
              .fail(function () {
                  Common.alert('File download failed!');                
                  Common.removeLoader();            
               });
           }else{
               Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>");
           }
       });
   }
   
   function onlyNumber(obj) {
       $(obj).keyup(function(){
            $(this).val($(this).val().replace(/[^0-9]/g,""));
       }); 
   }
</script>

<div id="popup_wrap2" class="popup_wrap"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>${prdDec }</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
        </ul>
    </header><!-- pop_header end -->
    
    <section class="pop_body" style="max-height:600px;"><!-- pop_body start -->
       <aside class="title_line"><!-- title_line start -->
          <h2>${prdNm } - ${prdDec }</h2>
        </aside><!-- title_line end -->
        
        <form id="form_24">
            <input type="hidden" name="actionType" id="actionType24T" value="${actionType }"/>  
            <input type="hidden" name="actionType" id="actionType" value="${actionType }"/>
           <input type="hidden" name="code" id="code_24T" value="${code}"/>
           <input type="hidden" id="fileName" name="fileName" value="CTMIncentivePerformance.xlsx"/>
           <ul class="right_btns">
              <li><p class="btn_blue"><a href="#" id="search_24T"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </ul>
    
            <table class="type1 mt10"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:130px" />
                    <col style="width:*" />
                    <col style="width:130px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Month/Year<span class="must">*</span></th>
                        <td>
                        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="CMM0024T_Dt" class="j_date2" value="${searchDt_pop }" />
                        </td>
                        <th scope="row">Employed CODE</th>
                        <td>
                              <input type="text" id="emplyCd_24T" name="emplyCd" style="width: 100px;" maxlength="10" >
                              <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                    </tr>
                </tbody>
            </table><!-- table end -->
        </form>
    
        <article class="grid_wrap3"><!-- grid_wrap start -->
            <!-- search_result start -->
            <ul class="right_btns">
                <li><p class="btn_grid">
                    <a href="javascript:fn_AlldownFile()" id="addRow"><span class="search"></span>ALL Excel</a>
                </p></li>
                <li><p class="btn_grid">
                    <a href="javascript:fn_downFile()" id="addRow"><span class="search"></span><spring:message code='sys.btn.excel.dw' /></a>
                </p></li>
            </ul>
            <!-- grid_wrap start -->
            <div id="grid_wrap_24T" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section>
    
</div>
