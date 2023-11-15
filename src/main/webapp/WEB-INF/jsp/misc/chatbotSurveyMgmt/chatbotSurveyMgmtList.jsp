<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<style type="text/css">
.aui-grid-left-column {
  text-align:left;
}

.my-green-style {
    background:#86E57F;
    font-weight:bold;
    color:#22741C;
}
</style>

<script type="text/javaScript">
    //AUIGrid 그리드 객체
    var myGridID;

    //Grid Properties 설정
    var gridPros = {
    		usePaging : true,
    	    pageRowCount : 20,
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
	    {dataField : "survQuesStr",headerText : "Survey Start Date",width : 130 , editable : false},
	    {dataField : "survQuesEnd",headerText : "Survey End Date",width : 130 , editable : false},
	    {dataField : "survStus",headerText : "Survey Status",width : 100 , editable : false},
	    {dataField : "userName",headerText : "Updated By",width : 130 , editable : false},
	    {dataField : "updDt",headerText : "Updated Date",width : 100 , editable : false},
	    {dataField : "survGrpId",headerText : "Survey Group Id",width : 100 , visible : false}
    ];


    $(document).ready(function(){
    	doGetCombo('/misc/chatbotSurveyMgmt/selectChatbotSurveyType', null, '' ,'surveyType' , 'S');

        //그리드 생성
//         myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout, null, gridPros);
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, gridPros);

    });

    // ajax list 조회.
    function searchList(){

        Common.ajax("GET","/misc/chatbotSurveyMgmt/selectChatbotSurveyMgmtList",$("#searchForm").serializeJSON(), function(result){
            AUIGrid.setGridData(myGridID, result);

            AUIGrid.setProp(myGridID, "rowStyleFunction", function(rowIndex, item) {
                if(item.flag == "IN USE") {
                	  return "my-green-style";
                }

             });
        });
    }

    function clearForm(){
    	console.log( $("#searchForm")[0]);
        $("#searchForm")[0].reset();
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
        	Common.popupDiv('/misc/chatbotSurveyMgmt/initChatbotSurveyMgmtEdit.do', {ctrlId :selectedItem[0].item.ctrlId, ctrlType:selectedItem[0].item.ctrlType, ctrlRem: selectedItem[0].item.ctrlRem, survGrpId: selectedItem[0].item.survGrpId}, null , true ,'_chatbotSurveyMgmtListEditPop');
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
	            <li><p class="btn_blue"><a href="javascript:clearForm();"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p></li>
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

                        <th scope="row">Survey Status</th>
                        <td>
                            <select id="surveyStatus" name="surveyStatus" class="w100p">
                                <option value="">Choose One</option>
                                <option value="1">Active</option>
                                <option value="8">Inactive</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Survey Start ~ End Date</th>
                        <td>
                            <p><input type="text" id="surveyFrDt" name="surveyFrDt" title="" placeholder="" class="j_date" /></p>
                            <span>~</span>
                            <p><input type="text" id="surveyToDt" name="surveyToDt" title="" placeholder="" class="j_date" /></p>
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

   <ul class="left_btns">
        <li><span class="green_text">Currently used</span></li>
    </ul>

    <!-- search_result start -->
    <section class="search_result">
        <!-- grid_wrap start -->
        <article id="grid_wrap" class="grid_wrap" style="width: 100%; height: 480px; margin: 0 auto;"></article>
        <!-- grid_wrap end -->
    </section>
    <!-- search_result end -->

</section>
<!-- content end -->