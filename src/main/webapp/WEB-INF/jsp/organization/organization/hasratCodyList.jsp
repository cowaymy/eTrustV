<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp"%>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
  text-align: left;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
  color: #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
  background: #D9E5FF;
  color: #000;
}

.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
  background: #D9E5FF;
  color: #000;
}

#emailContent{
    height: 500px;
    width: 100%
}
</style>

<script type="text/javaScript" language="javascript">
   var listGrid;

   $(document).ready(function() {
	    	   createAUIGrid();
	    	   /**********************************
	             * Header Setting
	             **********************************/
	             doGetComboData('/common/selectCodeList.do', {groupCode : '458'}, '${searchVal.sCategory}', 'sCategory', 'S', '');

	             var brnch = ('${SESSION_INFO.userBranchId}' == null || '${SESSION_INFO.userBranchId}' == "" ) ? 0 : '${SESSION_INFO.userBranchId}';
	             doGetComboData('/organization/codyBranchList.do', '', brnch, 'sCodyBranch', 'S', '');

	    	    /* AUIGrid.bind(listGrid, "ready", function(event) {
	            }); */

	    	   AUIGrid.bind(listGrid, "cellDoubleClick", function(event) {
	                 // display email content
	                 $("#emailContent").val(event.item.emailContent.replace(/<br\s?\/?>/g,"\n"));
	                 $("#viewWindow").show();
               });
	     }
	);

   function createAUIGrid() {
       var columnLayout = [
            {
                   dataField : "id",
                   headerText : "ID",
                   width : 100,
                   height : 30,
                   visible : false
             },
             {
               dataField : "codyEmail",
               headerText : "CODY Email",
               width : 200,
               height : 30
             },
             {
               dataField : "codyName",
               headerText : "CODY Name",
               width : 200,
               height : 30
             },
             {
               dataField : "category",
               headerText : "Category Of Issue",
               width : 150,
               height : 30
             },
             {
                 dataField : "branchcode",
                 headerText : "Branch Code",
                 width : 100,
                 height : 30
               },
             {
               dataField : "codyCode",
               headerText : "CODY Code",
               width : 120,
               height : 30
             },
             {
               dataField : "cmCode",
               headerText : "CM Code",
               width : 120,
               height : 30
             },
             {
               dataField : "scmCode",
               headerText : "SCM Code",
               width : 120,
               height : 30
             },
             {
               dataField : "gcmCode",
               headerText : "GCM Code",
               width : 120,
               height : 30
             },
             {
               dataField : "region",
               headerText : "Region",
               width : 130,
               height : 30
             },
             {
                 dataField : "emailContent",
                 headerText : "Email Content",
                 width : 200,
                 height : 30
             },
             {
                 dataField : "username",
                 headerText : "Create By",
                 width : 100,
                 height : 30
             },
             {
                 dataField : "crtdt",
                 headerText : "Create Date",
                 width : 100,
                 height : 30
             }];


        var resop = {
            //rowIdField : "rnum",
            usePaging : true,
            pageRowCount : 20,
            editable : false,
            //groupingFields : ["reqstno", "staname"],
            displayTreeOpen : false,
            //showStateColumn : false,
            showBranchOnGrouping : false
            //showRowNumColumn : true,
          };

        // default grid setup
        listGrid = AUIGrid.create("#grid_wrap", columnLayout, resop);
        //listGrid = GridCommon.createAUIGrid("#grid_wrap", columnLayout, '', resop);
   }

   /* $(function() {
       $('#search').click(function() {
           searchList();
       });

       /* $('#new').click(
           function() {
               $("#actionType").val("ADD");
               //Common.popupDiv("/organization/hasratCodyNewPop.do", $("#searchForm").serializeJSON(), null, false, '');
               Common.popupDiv("/organization/hasratCodyNewPop.do?isPop=true", "");
           });

       $("#clear").click(function(){
    	   AUIGrid.setGridData(listGrid, []);
       });
   }); */

   function fn_newHasratCody() {
	   Common.popupDiv("/organization/hasratCodyNewPop.do?isPop=true", "");
	   //Common.popupDiv("/organization/branchNewPop.do?isPop=true", "");
   }

   function fn_excelDown(){
       // type : "xlsx", "csv", "txt", "xml", "json", "pdf", "object"
       GridCommon.exportTo("grid_wrap", "xlsx", "Hasrat Cody List");
   }

   function fn_clear(){
	   AUIGrid.setGridData(listGrid, []);
   }


   function fn_searchList() {
	   Common.ajax("GET", "/organization/hasratCodySearchList.do", $("#searchForm").serialize(), function(result) {
    	   AUIGrid.setGridData(listGrid, result);
    	  // console.warn(result);
       });
   }

</script>
<section id="content"><!-- content start -->
 <ul class="path">
  <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
  <li>organization</li>
  <li>Hasrat CODY List</li>
 </ul>

 <aside class="title_line">
  <!-- title_line start -->
  <p class="fav">
   <a href="#" class="click_add_on">My menu</a>
  </p>
  <h2>Hasrat CODY List</h2>
 </aside>
 <!-- title_line end -->
  <c:if test="${PAGE_AUTH.funcView == 'Y'}">
  <ul class="right_btns">
     <li>
        <p class="btn_blue"><a href="#" onclick="javascript:fn_searchList();"><span class="search"></span>Search</a></p>
     </li>
     <li>
        <p class="btn_blue"><a href="#" onclick="javascript:fn_clear();"><span class="clear"></span>Clear</a></p>
     </li>
  </ul>
  </c:if>
 <section class="search_table">
 <!-- search_table start -->
 <form action="#" id="searchForm" name="searchForm" method="post">
    <!-- <input type="hidden" name="idNo" id="idNo" /> -->

    <table class="type1">
    <!-- table start -->
        <caption>search table</caption>
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
	           <th scope="row">CODY Code</th>
                <td><input type="text" class="w100p" id="sCodyCode" name="sCodyCode"></td>
                <th scope="row">CODY Branch</th>
                <td><select class="w100p" id="sCodyBranch" name="sCodyBranch"></select></td>
                <th scope="row">Category of Issue</th>
                <td><select class="w100p" id="sCategory" name="sCategory"></select></td>
	       </tr>
	       <tr>
               <th scope="row">CODY Email</th>
                <td><input type="text" class="w100p" id="sCodyEmail" name="sCodyEmail"></td>
                <th scope="row">Create Date</th>
                <td>
                    <div class="date_set w100p">
			        <!-- date_set start -->
				        <p>
				            <input id="crtsdt" name="crtsdt" type="text" title="Create start Date" value="${searchVal.crtsdt}" placeholder="DD/MM/YYYY" class="j_date">
				        </p>
			            <span> To </span>
				        <p>
				            <input id="crtedt" name="crtedt" type="text" title="Create End Date" value="${searchVal.crtedt}" placeholder="DD/MM/YYYY" class="j_date">
				        </p>
			         </div>
			    </td>
			    <th scope="row"></th>
                <td></td>
           </tr>
	    </tbody>
    </table>
    <!-- table end -->
 </form>
 </section>
 <!-- search_table end -->
 <!-- data body start -->
 <section class="search_result">
 <!-- search_result start -->
 <ul class="right_btns">
    <c:if test="${PAGE_AUTH.funcChange == 'Y'}">
        <li><p class="btn_grid"><a id="new" onclick="javascript:fn_newHasratCody();">New</a></p></li>
    </c:if>
    <c:if test="${PAGE_AUTH.funcPrint == 'Y'}">
        <li><p class="btn_grid"><a id="download" onclick="javascript:fn_excelDown();"><spring:message code='sys.btn.excel.dw' /></a></p></li>
    </c:if>
 </ul>

<article class="grid_wrap">
    <div id="grid_wrap" style="width: 100%; height: 530px; margin: 0 auto;"></div>
 </article>
 </section>
 <!-- search_result end -->

 <!-- Detail Pop up form start -->
 <!-- <form id='popupForm'>
    <input type="hidden" id="sUrl" name="sUrl">
    <input type="hidden" id="svalue" name="svalue">
 </form> -->
 <section>
 <div class="popup_wrap" id="viewWindow" style="display:none"><!-- popup_wrap start -->
    <header class="pop_header">
    <h1>Email Content</h1>
    <ul class="right_opt">
	    <li><p class="btn_blue2"><a href="#">CLOSE</a></p></li>
	</ul>
    </header>
    <section class="pop_body"><!-- pop_body start -->
        <table class="type1">
            <tr>
                <td><textarea cols="20" rows="100" id="emailContent" name="emailContent" placeholder="Email Content" readonly></textarea></td>
            </tr>
        </table>
    </section>
 </div>
  <!-- Detail Pop up form end -->
</section>
</section>