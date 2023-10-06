<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.aui-grid-left-column {
  text-align:left;
}
</style>

<script type="text/javaScript">
    //AUIGrid 그리드 객체
    var myGridID;

    //Grid Properties 설정
    var gridPros = {
	       // 편집 가능 여부 (기본값 : false)
	       editable : false,
	       // 상태 칼럼 사용
	       showStateColumn : false,
	       // 기본 헤더 높이 지정
	       headerHeight : 35,

	       softRemoveRowMode:false

    };

    // AUIGrid 칼럼 설정
    var columnLayout = [
	    {dataField : "ctrlId",headerText : "Ctrl ID",width : 100 , editable : false, visible: false},
	    {dataField : "ctrlType",headerText : "Ctrl Type ID",width : 80 , editable : false, visible: false},
	    {dataField : "survType",headerText : "Survey Type",width : 180 , editable : false},
	    {dataField : "ctrlRem",headerText : "Survey Name",width : 500 , editable : false,style : "aui-grid-left-column"},
	    {dataField : "ctrlStrYyyymm",headerText : "Survey Start Date",width : 130 , editable : false},
	    {dataField : "ctrlEndYyyymm",headerText : "Survey End Date",width : 130 , editable : false},
	    {dataField : "ctrlUseYn",headerText : "Use YN",width : 100 , editable : false},
	    {dataField : "userName",headerText : "Updated By",width : 130 , editable : false},
	    {dataField : "updDt",headerText : "Updated Date",width : 100 , editable : false}
    ];


    $(document).ready(function(){
    	doGetCombo('/misc/chatbotSurveyMgmt/selectChatbotSurveyType', null, '' ,'surveyType' , 'S');

        //그리드 생성
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, null, gridPros);

    });

    // ajax list 조회.
    function searchList(){

        Common.ajax("GET","/misc/chatbotSurveyMgmt/selectChatbotSurveyMgmtList",$("#searchForm").serializeJSON(), function(result){
            AUIGrid.setGridData(myGridID, result);
        });
    }

    function fn_syncSurvey(){
    	Common.ajax("POST","/misc/chatbotSurveyMgmt/pushSurveyQues.do", $("#searchForm").serializeJSON(), function(result){
    		console.log(result);

    		if(result.status = "00"){
    			Common.alert("Synch successful.");
    		}else {
    			Common.alert("Synch unsuccessful. Please try again later.");
    		}
        });
    }

    function fn_editSurvey(){
        var selectedItem = AUIGrid.getSelectedItems(myGridID);

        if(selectedItem.length <=0 || selectedItem == null){
        	 Common.alert("Please select a survey to perform edit action.");
             return;

        } else {
        	Common.popupDiv('/misc/chatbotSurveyMgmt/initChatbotSurveyMgmtEdit.do', {ctrlId :selectedItem[0].item.ctrlId, ctrlType:selectedItem[0].item.ctrlType, ctrlRem: selectedItem[0].item.ctrlRem}, null , true ,'_chatbotSurveyMgmtListEditPop');
        }
    }

</script>


<!-- content start -->
<section id="content">
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    </ul>

    <!-- title_line start -->
    <aside class="title_line">
        <p class="fav"><a href="#" class="click_add_on"><spring:message code='pay.text.myMenu'/></a></p>
        <h2>Survey Management</h2>

        <c:if test="${PAGE_AUTH.funcView == 'Y'}">
	        <ul class="right_btns">
	            <li><p class="btn_blue"><a href="javascript:searchList();"><span class="search"></span><spring:message code='sys.btn.search'/></a></p></li>
	        </ul>
        </c:if>
    </aside>
    <!-- title_line end -->

    <!-- search_table start -->
    <section class="search_table">
        <!-- search_table start -->
        <form id="searchForm" action="#" method="post">
            <input type="hidden" name="ordId" id="ordId" />
            <table class="type1">
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px" />
                    <col style="width:*" />
                    <col style="width:180px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">Survey Type</th>
                        <td>
                            <select id="surveyType" name="surveyType" class="w100p"></select>
                        </td>

                        <th scope="row">Use YN</th>
                        <td>
                            <select id="useYN" name="useYN" class="w100p">
                                <option value="">Choose One</option>
                                <option value="Y">Y</option>
                                <option value="N">N</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Survey Start ~ End Date</th>
                        <td>
                            <p><input type="text" id="surveyFrDt" name="surveyFrDt" title="" placeholder="" class="j_date2" /></p>
                            <span>~</span>
                            <p><input type="text" id="surveyToDt" name="surveyToDt" title="" placeholder="" class="j_date2" /></p>
                        </td>
                    </tr>
                </tbody>
            </table>
            <!-- table end -->
        </form>
    </section>
    <!-- search_table end -->

	<ul class="right_btns">
		<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
		  <li><p class="btn_grid"><a href="javascript:fn_syncSurvey();">Synchronize</a></p></li>
        </c:if>
        <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
		  <li><p class="btn_grid"><a href="javascript:fn_editSurvey();">Edit</a></p></li>
		</c:if>
	</ul>

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</section>
<!-- content end -->