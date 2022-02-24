<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>

<script type="text/javaScript">
$(document).ready(function() {

    if("${PAGE_AUTH.funcUserDefine1}" != 'Y') {
        $("#caseNoLbl").remove();
        $("#caseNoCol").remove();
    }

    ComplianceListGrid();
    fn_search()

});
var myGridID;
function ComplianceListGrid() {
    //AUIGrid 칼럼 설정
    var columnLayout = [{
        dataField : "webcrawlNo",
        headerText : "WebCrawl No",
        editable : false,
        width : 100
    }, {
        dataField : "title",
        headerText : "Title",
        editable : false,
        visible : true,
        width : 350
    }, {
        dataField : "url",
        headerText : "URL Link",
        editable : false,
        width : 400,
        renderer : {
            type : "LinkRenderer",
            linkField : "url" // 기본 URL
     }
    }, {
        dataField : "status",
        headerText : "Status",
        width : 150,
        //editable : false,
        renderer : {
            type: "DropDownListRenderer",
            list : ["Active","In Progress","Closed","Cancelled"],
      }
    }, {
        dataField : "remark",
        headerText : "GOC Reference",
        visible : true,
        editable : true,
        width : 150
    },{
        dataField : "webcrawlCrtDt",
        headerText : "Created Date",
        editable : false,
        width : 100,
        dataType : "date",
        formatString : "dd/mm/yyyy"
    },  {
        dataField : "webcrawlUdpUser",
        headerText : "Last Update At (By)",
        editable : false,
        width : 150,
        visible : true
    }
    /////////////////////////// ADDITIONAL FIELD //////////////////////////////
    ];


    // 그리드 속성 설정
   var gridPros = {
       usePaging : true, // 페이징 사용
       pageRowCount : 20, // 한 화면에 출력되는 행 개수 20(기본값:20)
       editable : true,
       displayTreeOpen : true,
       selectionMode : "singleRow",
       headerHeight : 30,
       skipReadonlyColumns : true, // 읽기 전용 셀에 대해 키보드 선택이 건너 뛸지 여부
       wrapSelectionMove : true, // 칼럼 끝에서 오른쪽 이동 시 다음 행, 처음 칼럼으로 이동할지 여부
       showRowNumColumn : true, // 줄번호 칼럼 렌더러 출력
       wordWrap :  true
   };

    myGridID = GridCommon.createAUIGrid("#grid_wrap_complianceList", columnLayout,'', gridPros);
}


function fn_setOptGrpClass() {
    $("optgroup").attr("class" , "optgroup_text")
}
function fn_search(){
	console.log("FN_SEARCH")
	console.log($("#WebCrawlSearch").serialize());
	Common.ajax("GET", "/organization/compliance/WebCrawlResult.do",$("#WebCrawlSearch").serialize(), function(result) {
        AUIGrid.setGridData(myGridID, result);
    });
}
function fn_save(){

    var editedRowItems = AUIGrid.getEditedRowItems(myGridID);

    if(editedRowItems.length <= 0) {
        Common.alert("<spring:message code="sal.alert.msg.noUpdateItem" />");
        return ;
    }
    console.log(editedRowItems)
    param = GridCommon.getEditData(myGridID);
    console.log("Param= ",typeof param);
    console.log("Param2= ",param);
    console.log("Param3= ",typeof param["update"]);
    console.log("Param4= ",param["update"]);

    Common.confirm("<spring:message code='sys.common.alert.save'/>",function(){
        Common.ajax("POST", "/organization/compliance/SaveLinkStatus.do", param, function(result) {

        }, function(jqXHR, textStatus, errorThrown) {
        });
    });


}

</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Compliance Call Log</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Web Crawl Log</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_search()"><span class="search"></span>Search</a></p></li>
   </ul>
</aside><!-- title_line end -->


<section class="search_table"><!-- search_table start -->
<form action="#" method="post" id="WebCrawlSearch">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
</colgroup>
<tbody>
<th scope="row">Web Log Status  </th>
    <td>
        <select class="multy_select w100p" multiple="multiple" id="link_status" name="link_status">
            <option value="1" selected>Active</option>
            <option value="60" selected>In Progress</option>
            <option value="36" >Closed</option>
            <option value="10">Cancelled</option>
        </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<ul class="right_btns">
<c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
    <li><p class="btn_grid"><a onclick="javascript:fn_save()">Save</a></p></li>
</c:if>
</ul>

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="grid_wrap_complianceList" style="width: 100%; height: 500px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->

