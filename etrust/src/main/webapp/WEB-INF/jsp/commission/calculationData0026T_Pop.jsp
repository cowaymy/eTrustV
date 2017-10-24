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
    var myGridID_26T;
    var gridDataLength = 0;
    
    $(document).ready(function() {
        createAUIGrid();
        
        // ready 이벤트 바인딩
        AUIGrid.bind(myGridID_26T, "ready", function(event) {
            gridDataLength = AUIGrid.getGridData(myGridID_26T).length; // 그리드 전체 행수 보관
        });
        
        // cellClick event.
        AUIGrid.bind(myGridID_26T, "cellClick", function(event) {
              console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");          
        });
        
     // 헤더 클릭 핸들러 바인딩
        AUIGrid.bind(myGridID_26T, "headerClick", function(event) {
            // isExclude 칼럼 클릭 한 경우
            if(event.dataField == "isExclude") {
                if(event.orgEvent.target.id == "allCheckbox") { // 정확히 체크박스 클릭 한 경우만 적용 시킴.
                    var  isChecked = document.getElementById("allCheckbox").checked;
                    checkAll(isChecked);
                }
                return false;
            }
        });
         
        //Rule Book Item search
        $("#search_26T").click(function(){
        	/* var emplyId = $("#emplyId_26T").val();
            
            if(emplyId == "" || emplyId == null){
            	Common.alert("<spring:message code='sys.msg.necessary' arguments='order Id' htmlEscape='false'/>");
                return false;
            }else{ */
	            Common.ajax("GET", "/commission/calculation/selectDataCMM026T", $("#form_26").serialize(), function(result) {
	                console.log("성공.");
	                console.log("data : " + result);
	                AUIGrid.setGridData(myGridID_26T, result);
	                AUIGrid.addCheckedRowsByValue(myGridID_26T, "isExclude", "1");
	            });
            //}
        });
        
        $("#save_26T").click(function(){  
        	/* var emplyId = $("#emplyId_26T").val();
            
            if(emplyId == "" || emplyId == null){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='order Id' htmlEscape='false'/>");
                return false;
            }else{ */
            	Common.confirm("<spring:message code='sys.common.alert.save'/>",fn_saveExculde);
	        	
            //}
        });
        
        $('#memBtn').click(function() {
            //Common.searchpopupWin("searchForm", "/common/memberPop.do","");
            Common.popupDiv("/common/memberPop.do", $("#form_26").serializeJSON(), null, true);
        });
        
    });
    
    function fn_loadOrderSalesman(memId, memCode) {
        $("#emplyCd_26T").val(memCode);
        console.log(' memId:'+memId);
        console.log(' memCd:'+memCode);
    }
    
    function fn_saveExculde(){
        Common.ajax("POST", "/commission/calculation/updatePrdData_26T.do", GridCommon.getEditData(myGridID_26T) , function(result) {
            // 공통 메세지 영역에 메세지 표시.
            Common.setMsg("<spring:message code='sys.msg.success'/>");
            $("#search_26T").trigger("click");
        });
    }
   function createAUIGrid() {
    var columnLayout3 = [ {
        dataField : "isExclude",
        headerText : 'exclude<br/><input type="checkbox" id="allCheckbox" style="width:15px;height:15px;">',
        width: 65,
        renderer : {
            type : "CheckBoxEditRenderer",
            showLabel : false, // 참, 거짓 텍스트 출력여부( 기본값 false )
            editable : true, // 체크박스 편집 활성화 여부(기본값 : false)
            checkValue : "1", // true, false 인 경우가 기본
            unCheckValue : "0"
        }
    }, {
        dataField : "emplyTypeCode",
        headerText : "GROUP</BR> CODE",
        style : "my-column",
        width: 65,
        editable : false
    }, {
        dataField : "grpName",
        headerText : "ORG NAME",
        style : "my-column",
        width: 170,
        editable : false
    }, {
        dataField : "emplyId",
        headerText : "EMPLY ID",
        style : "my-column",
        editable : false
    },{
        dataField : "emplyCode",
        headerText : "EMPLY</BR>CODE",
        style : "my-column",
        editable : false
    },{
        dataField : "week1",
        headerText : "WEEK1",       
        width: 60,
        editable : false
    },{
        dataField : "week2",
        headerText : "WEEK2",      
        width: 60,
        editable : false
    },{
        dataField : "week3",
        headerText : "WEEK3",      
        width: 60,
        editable : false
    },{
        dataField : "week4",
        headerText : "WEEK4",       
        width: 60,
        editable : false
    },{
        dataField : "tot",
        headerText : "TOTAL",      
        width: 60,
        editable : false
    },{
        dataField : "totLv",
        headerText : "TOTAL</BR> COMPLETE",    
        width: 80,
        editable : false
    },{
        dataField : "cAward",
        headerText : "AWARD",
        style : "my-column",
        width: 100,
        editable : false
    },{
        dataField : "lAward",
        headerText : "AWARD</BR>(Last Month)",
        style : "my-column",
        width: 100,
        editable : false
    },{
        dataField : "cCriteria",
        headerText : "CRITERIA",
        style : "my-column",
        width: 100,
        editable : false
    },{
        dataField : "lCriteria",
        headerText : "CRITERIA</BR>(Last Month)",
        style : "my-column",
        width: 100,
        editable : false
    },{
        dataField : "runId",
        headerText : "RUN ID",
        style : "my-column",
        visible : false,
        editable : false
    },{
        dataField : "taskId",
        headerText : "TASK ID",
        style : "my-column",
        visible : false,
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
    myGridID_26T = AUIGrid.create("#grid_wrap_26T", columnLayout3,gridPros);
   }
   
   // 전체 체크 설정, 전체 체크 해제 하기
   function checkAll(isChecked) {
       var rowCount = AUIGrid.getRowCount(myGridID_26T);
       
       if(isChecked){   // checked == true == 1
         for(var i=0; i<rowCount; i++){
            AUIGrid.updateRow(myGridID_26T, { "isExclude" : 1 }, i);
         }
       }else{   // unchecked == false == 0
         for(var i=0; i<rowCount; i++){
            AUIGrid.updateRow(myGridID_26T, { "isExclude" : 0 }, i);
         }
       }
       
       // 헤더 체크 박스 일치시킴.
       document.getElementById("allCheckbox").checked = isChecked;
   };
   
   function fn_downFile() {
       Common.ajax("GET", "/commission/calculation/cntCMM0026T", $("#form_26").serialize(), function(result) {
           var cnt = result;
           if(cnt > 0){
               /* var emplyId = $("#emplyId_26T").val();
               
               if(emplyId == "" || emplyId == null){
                   Common.alert("<spring:message code='sys.msg.necessary' arguments='order Id' htmlEscape='false'/>");
                   return false;
               }else{ */
                   //excel down load name 형식 어떻게 할지?
                   var fileName = $("#fileName").val();
                   var searchDt = $("#CMM0026T_Dt").val();
                   var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
                   var month = searchDt.substr(0,searchDt.indexOf("/"));
                   var code = $("#code_26T").val();
                   
                   var codeId= $("#orgGroup_26").val();
                   var emplyCd = $("#emplyCd_26T").val();
                   var useYnCombo = $("#useYnCombo_26T").val();
                   //window.open("<c:url value='/sample/down/excel-xls.do?aaa=" + fileName + "'/>");
                   //window.open("<c:url value='/sample/down/excel-xlsx.do?aaa=" + fileName + "'/>");
                   window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&emplyCd="+emplyCd+"&useYnCombo="+useYnCombo+"&codeId="+codeId+"'/>";
               //}
           }else{
               Common.alert("<spring:message code='sys.info.grid.noDataMessage'/>");
           }
       });
   } 
   
   function fn_AlldownFile() {
	   var data = { "searchDt" : $("#CMM0026T_Dt").val() , "code": $("#code_26T").val(), "codeId": $("#orgGroup_26").val() };
	   Common.ajax("GET", "/commission/calculation/cntCMM0026T", data, function(result) {
           var cnt = result;
           if(cnt > 0){
		      var fileName = $("#fileName").val();
		      var searchDt = $("#CMM0026T_Dt").val();
		      var year = searchDt.substr(searchDt.indexOf("/")+1,searchDt.length);
		      var month = searchDt.substr(0,searchDt.indexOf("/"));
		      var code = $("#code_26T").val();
		      var codeId= $("#orgGroup_26").val();
		      window.location.href="<c:url value='/commExcelFile.do?fileName=" + fileName + "&year="+year+"&month="+month+"&code="+code+"&codeId="+codeId+"'/>";
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
        
        <form id="form_26">
           <input type="hidden" name="code" id="code_26T" value="${code}"/>
           <input type="hidden" id="fileName" name="fileName" value="Award.xlsx"/>
           <ul class="right_btns">
              <li><p class="btn_blue"><a href="#" id="search_26T"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
            </ul>
    
            <table class="type1 mt10"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:100px" />
                    <col style="width:*" />
                    <col style="width:100px" />
                    <col style="width:*" />
                    <col style="width:100px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Month/Year<span class="must">*</span></th>
                        <td>
                        <input type="text" title="Create start Date" placeholder="DD/MM/YYYY" name="searchDt" id="CMM0026T_Dt" class="j_date2" value="${searchDt_pop }" />
                        </td>
                        <th scope="row">ORG Group<span class="must">*</span></th>
                        <td><select id="orgGroup_26" name="codeId" style="width: 100px;">
                                <c:forEach var="list" items="${orgGrList }">
                                    <option value="${list.cdid}">${list.cd}</option>
                                </c:forEach>
                        </select></td>
                        <th scope="row">Employed Code<span class="must">*</span></th>
                        <td>
                              <input type="text" id="emplyCd_26T" name="emplyCd" style="width: 100px;" maxlength="10" >
                              <a id="memBtn" href="#" class="search_btn"><img src="${pageContext.request.contextPath}/resources/images/common/normal_search.gif" alt="search" /></a>
                        </td>
                     </tr>
                     <tr>
                        <th scope="row">is Exclude</th>
                        <td colspan=5>
                          <select id="useYnCombo_26T" name="useYnCombo" style="width:100px;">
                            <option value=""selected></option>
                            <option value="1">Y</option>
                            <option value="0">N</option>
                        </select>
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
                <li><p class="btn_grid">
                    <a href="#" id="save_26T"><spring:message code='sys.btn.save'/></a>
                </p></li>
            </ul>
            <!-- grid_wrap start -->
            <div id="grid_wrap_26T" style="width: 100%; height: 334px; margin: 0 auto;"></div>
        </article><!-- grid_wrap end -->
    </section>
    
</div>
