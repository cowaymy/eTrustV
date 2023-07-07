<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

.mycustom-disable-color {color : #cccccc;}

.aui-grid-body-panel table tr:hover {background:#D9E5FF; color:#000;}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {background:#D9E5FF; color:#000;}
.aui-grid-user-custom-left {text-align:left;}
.aui-grid-user-custom-right {text-align:right;}

.pop_body{max-height:535px; padding:10px; background:#fff; overflow-y:scroll;}

.popup_wrap2{max-height:525px; position:fixed; top:20px; left:50%; z-index:1001; margin-left:-500px; width:1000px; background:#fff; border:1px solid #ccc;}
.popup_wrap2:after{content:""; display:block; position:fixed; top:0; left:0; z-index:-1; width:100%; height:100%; background:rgba(0,0,0,0.6);}
.popup_wrap2.size_big2{width:1240px!important; margin-left:-620px!important;}
.pop_body2{height:505px; padding:10px; background:#fff; overflow-y:scroll;}
</style>

<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

var selectRowIdx, selectBatchId, selectAtchGrpId, selectAppvPrcssNo, selectAppvPrcssStus;
var mode;

var attachList = null;

// **************
// Grid Layout - Start
// **************

var myGridID;

// Main Menu Grid Layout
var columnLayout = [
    {
        dataField : "entId",
        headerText : "Entitlement ID",
        cellMerge : true,
        width : "10%"
    },{
        dataField : "hpCode",
        headerText : "Hp Code",
        width : "15%",
        visible : true,
        cellMerge : true
    },{
        dataField : "hpLevel",
        headerText : "Level",
        width : "10%",
        visible : true,
        cellMerge : true
    },{
        dataField : "entMonth",
        headerText : "Month",
        width : "10%",
        visible : true,
        cellMerge : true
    },{
        dataField : "entAmt",
        headerText : "Entitlement",
        style : "aui-grid-user-custom-right",
        width : "10%",
        visible : true,
        dataType: "numeric",
        formatString : "#,##0.00"
    },{
        dataField : "crtDt",
        headerText : "Upload Date",
        width : "10%",
        visible : true
    },{
        dataField : "crtUserId",
        headerText : "Uploader",
        width : "10%",
        visible : true
    }
];

// Main Menu + Upload Result Grid Option
var mGridoptions = {
    showStateColumn : false ,
    editable : false,
    pageRowCount : 20,
    usePaging : true,
    showPageRowSelect : true,
    showRowNumColumn : false,
    setColumnSizeList : true
};

// **************
// Grid Layout - End
// **************

$(document).ready(function(){

	$("#newUpload").click(fn_newUpload);

    myGridID = AUIGrid.create("#grid_wrap", columnLayout, mGridoptions);

});

function fn_newUpload() {

	Common.popupDiv("/eAccounting/smGmClaim/entitlementNewPop.do");
    /* $("#new_pop_header").text("New Entitlement Upload");

    $("#uploadContent").hide();
    $("#suppDocFile").hide();
    $("#suppDocFileSelector").hide();
    $("#proceedBtn").hide();
    $("#viewAppvLbl").hide();
    $("#bulkAppvBtns").hide();
    $("#bulkFilesUploadRow").show();
    $("#bulkGenDtls").hide();

    AUIGrid.hideColumnByDataField(bulkInvcGrid, "clmNo"); */
}


function fn_searchUpload() {
    if(myGridID == null) {
        //myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"appvPrcssNo", gridoptions);
        myGridID = AUIGrid.create("#grid_wrap", columnLayout, mGridoptions);
    }

    Common.ajax("GET", "/eAccounting/smGmClaim/selectSmGmEntitlementList.do",  $('#SearchForm').serialize(), function(result) {
        console.log(result);
        AUIGrid.setGridData(myGridID, result);

        AUIGrid.setCellMerge(myGridID, true);
    });
}

</script>
</head>
<body>

<form id="rptForm">
    <input type="hidden" id="reportFileName" name="reportFileName" />
    <input type="hidden" id="viewType" name="viewType" value="PDF" />
    <input type="hidden" id="reportDownFileName" name="reportDownFileName" value="" />
    <input type="hidden" id="V_CLMNO" name="V_CLMNO" />
    <input type="hidden" id="V_BATCHID" name="V_BATCHID" />
</form>

<form id="dataForm">
    <input type="hidden" id="mode" name="mode" value="" />
    <input type="hidden" id="batchInvcSeq" name="batchInvcSeq" value="" />

    <input type="hidden" id="atchFileGrpId" name="atchFileGrpId" value="" />
    <input type="hidden" id="atchFileCSVId" name="atchFileCSVId" value="" />
    <input type="hidden" id="atchFileSuppId" name="atchFileSuppId" value="" />
</form>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
        <li>E-Accounting</li>
        <li>Entitlement</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="#" class="click_add_on">My menu</a></p>
        <h2>Entitlement</h2>
        <ul class="right_btns">
            <li><p class="btn_blue"><a href="#" onclick="javascript:fn_searchUpload()"><span class="search"></span><spring:message code="webInvoice.btn.search" /></a></p></li>
        </ul>
    </aside><!-- title_line end -->


    <section class="search_table"><!-- search_table start -->
        <form id="SearchForm" name="SearchForm"   method="post">

        <c:if test="${PAGE_AUTH.funcUserDefine2  != 'Y'}"> <!-- 'N' see own entitlement only,'Y' can see all entitlement -->
            <input type="hidden" id="loginUserId" name="loginUserId" value='${SESSION_INFO.userName}'>
        </c:if>
        <c:if test="${PAGE_AUTH.funcUserDefine2  == 'Y'}"> <!-- 'Y' admin -->
            <input type="hidden" id="adminUserId" name="adminUserId" value='${SESSION_INFO.userName}'>
        </c:if>
            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:200px" />
                    <col style="width:*" />
                    <col style="width:200px" />
                    <col style="width:*" />
                </colgroup>
                <tbody>
                    <tr>
                        <th scope="row">HP Code</th>
                        <td>
                            <div class="date_set w100p">
                                <p><input type="text" title="Hp Code" id="hpCode" name="hpCode" class="w100p" /></p>
                            </div>
                        </td>
                        <th scope="row">Member Type</th>
                        <td>
                            <select class="multy_select" multiple="multiple" id="memberType" name="memberType">
                                <option value="GM">GM</option>
                                <option value="SM">SM</option>
                                <option value="HM">HM</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Month</th>
                        <td>
                            <div class="date_set w100p"><!-- date_set start -->
                                <p><input type="text" title="Month" placeholder="MM/YYYY" class="j_date2" id="entMonth" name="entMonth"/></p>
                            </div>
                        </td>
                        <th scope="row">Entitlement</th>
                        <td>
                            <select class="multy_select" multiple="multiple" id="entAmt" name="entAmt">
                                <option value="3000">RM 3,000</option>
                                <option value="2000">RM 2,000</option>
                                <option value="1500">RM 1,500</option>
                                <option value="1000">RM 1,000</option>
                                <option value="500">RM 500</option>
                            </select>
                        </td>
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
			            <!-- <li><p class="btn_blue"><a href="#" onclick="javascript:fn_newUpload('NEW')">New Upload</a></p></li> -->
			            <li><p class="link_btn"><a href="#" id="newUpload">New Upload</a></p></li>
			            </c:if>
			        </ul>
			        <ul class="btns">
			        </ul>
			        <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
			        </dd>
			    </dl>
			    </aside><!-- link_btns_wrap end -->
        </form>
    </section><!-- search_table end -->


    <article class="grid_wrap"><!-- grid_wrap start -->
        <div id="grid_wrap"></div>
    </article><!-- grid_wrap end -->
</section><!-- search_result end -->
