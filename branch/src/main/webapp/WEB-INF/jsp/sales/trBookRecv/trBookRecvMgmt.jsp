<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<script  type="text/javascript">
var recvGridID;

$(document).ready(function(){

    creatGrid();
     
});


function creatGrid(){

        var recvColLayout = [ 
              {dataField : "trnsitId", headerText : "", width : 140  , visible:false   },
              {dataField : "trnsitNo", headerText : "<spring:message code="sal.title.transitNo" />", width : 150      },
              {dataField : "trnsitDt", headerText : "<spring:message code="sal.title.date" />", width : 150       },
              {dataField : "trnsitFrom", headerText : "<spring:message code="sal.title.from" />", width : 130        },
              {dataField : "trnsitTo", headerText : "<spring:message code="sal.title.to" />", width : 130        },
              {dataField : "trnsitStusCode", headerText : "<spring:message code="sal.title.status" />", width : 150      },
              {dataField : "trnsitCrtUserId", headerText : "<spring:message code="sal.title.by" />", width : 150     },
              {dataField : "trnsitTotBook", headerText : "<spring:message code="sal.title.totalBook" />", width : 140       }             
              ];
        

        var recvOptions = {
                   showStateColumn:false,
                   showRowNumColumn    : false,
                   usePaging : true,
                   editable : false//,
                   //selectionMode : "singleRow"
             }; 
        
        recvGridID = GridCommon.createAUIGrid("#recvGridID", recvColLayout, "", recvOptions);
        
        // 셀 더블클릭 이벤트 바인딩
         AUIGrid.bind(recvGridID, "cellDoubleClick", function(event){
             
              $("#trnsitId").val(AUIGrid.getCellValue(recvGridID , event.rowIndex , "trnsitId"));
             
              Common.popupDiv("/sales/trBookRecv/trBookRecvViewPop.do",$("#listSForm").serializeJSON(), null, true, "trBookRecvViewPop");
              
         });
        // 셀 더블클릭 이벤트 바인딩
         AUIGrid.bind(recvGridID, "cellClick", function(event){            
              $("#trnsitId").val(AUIGrid.getCellValue(recvGridID , event.rowIndex , "trnsitId"));              
         });
}

//리스트 조회.
function fn_selectListAjax() {
    $("#trnsitId").val("");
    
    Common.ajax("GET", "/sales/trBookRecv/selectTrBookRecvList", $("#listSForm").serialize(), function(result) {
      
       console.log("성공.");
       console.log( result);
       
      AUIGrid.setGridData(recvGridID, result);

  });
}

function fn_clear(){
    $("#listSForm")[0].reset();
}


function fn_updateRecv(){

    if($("#trnsitId").val()==""){  
        Common.alert("<spring:message code="sal.alert.title.transitRecodeMissing" />" + DEFAULT_DELIMITER + "<spring:message code="sal.alert.msg.transitRecodeMissing" />");
    }else{ 
        Common.popupDiv("/sales/trBookRecv/updateRecvPop.do",$("#listSForm").serializeJSON(), null, true, "updateRecvPop");
    }
}

function fn_trBookSummary(){
    Common.popupDiv("/sales/trBookRecv/trBookSummaryPop.do",null, null, true, "_trBookSummary");
}
</script>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Sales</li>
    <li>TR Book</li>
    <li>TR Book Management</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2><spring:message code="sal.page.title.trBookRecv" /></h2>
<ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_updateRecv();"><spring:message code="sal.btn.updRecv" /></a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcView == 'Y'}">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_selectListAjax();"><span class="search"></span><spring:message code="sal.btn.search" /></a></p></li>
    </c:if>
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_clear();"><span class="clear"></span><spring:message code="sal.btn.clear" /></a></p></li>
</ul>
</aside><!-- title_line end -->

<form action="#" method="post" id="listSForm" name="listSForm">
<input type="hidden" id="trnsitId" name="trnsitId">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
    <col style="width:150px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row"><spring:message code="sal.text.transitNo" /></th>
    <td>
    <input type="text" title="" placeholder="<spring:message code="sal.text.transitNo" />" class="w100p" id="trnsitNo" name="trnsitNo"/>
    </td>
    <th scope="row"><spring:message code="sal.text.bookNo" /></th>
    <td>
    <input type="text" title="" placeholder="<spring:message code="sal.text.bookNo" />" class="w100p" id="trBookNo" name="trBookNo"/>
    </td>
    <th scope="row"><spring:message code="sal.text.createDate" /></th>
    <td>
        <input type="text" title="" placeholder="DD/MM/YYYY" class="j_date w100p" id="trnsitDt" name="trnsitDt"/>
    </td>
</tr>
<tr>
    <th scope="row"><spring:message code="sal.text.createBy" /></th>
    <td>
    <input type="text" title="" placeholder="<spring:message code="sal.text.createBy" />" class="w100p" id="crtuserId" name="crtuserId"/>
    </td>
    <th scope="row"><spring:message code="sal.text.status" /></th>
    <td>
        <select class="w100p" id="trnsitStusId" name="trnsitStusId">
            <option value="1"><spring:message code="sal.combo.text.actPen" /></option>
            <option value="36"><spring:message code="sal.combo.text.closed" /></option>
        </select>
    </td>
    <td colspan="2"></td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <c:if test="${PAGE_AUTH.funcUserDefine1 == 'Y'}">
        <li><p class="link_btn type2"><a onclick="javascript : fn_trBookSummary()"><spring:message code="sal.btn.trBookSummary" /></a></p></li>
        </c:if>
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->
</form>
<section class="search_result"><!-- search_result start -->

<article class="grid_wrap"><!-- grid_wrap start -->
<div id="recvGridID" style="width:100%; height:400px; margin:0 auto;"></div>
</article><!-- grid_wrap end -->

</section><!-- search_result end -->

</section><!-- content end -->