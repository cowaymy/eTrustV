<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
}
.aui-grid-user-custom-right {
    text-align:right;
}

/* 커스컴 disable 스타일*/
.mycustom-disable-color {
    color : #cccccc;
}

/* 그리드 오버 시 행 선택자 만들기 */
.aui-grid-body-panel table tr:hover {
    background:#D9E5FF;
    color:#000;
}
.aui-grid-main-panel .aui-grid-body-panel table tr td:hover {
    background:#D9E5FF;
    color:#000;
}

</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">

//AUIGrid  ID
var mstGridID;
var myGridID;

var optionModule = {
        type: "S",
        isShowChoose: false
};

var optionSystem = {
        type: "M",
        isShowChoose: false
};

var columnLayout = [
                    {dataField: "scnNo",headerText :"No." ,width: 180 , height:30 , visible:false, editable : false},
                    {dataField: "scnMoveTypeCode",headerText :"Ref No.",width: 180    ,height:30 , visible:true, editable : false},
                    {dataField: "scnFromLocDesc",headerText :"POS No.",width:220   ,height:30 , visible:true, editable : false},
                    {dataField: "scnToLocDesc",headerText :"POS Type" ,width:220   ,height:30 , visible:true, editable : false},
                    {dataField: "scnMoveStatCode",headerText :"Status" ,width:120   ,height:30 , visible:true, editable : false},
                    {dataField: "crtDt",headerText :"Sales Date",width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "crdName",headerText :"Mmeber ID" ,width:140   ,height:30 , visible:true ,editable : false},
                    {dataField: "updDate",headerText :"Update Date",width:120   ,height:30 , visible:true,editable : false},
                    {dataField: "updName",headerText :"Update By",width:120   ,height:30 , visible:true,editable : false},
                    {dataField: "scnMoveStat",headerText :"Courier Service",width:120   ,height:30 , visible:true ,editable : false},
                    {dataField: "scnMoveType",headerText :"Waybill No",width:120   ,height:30 , visible:true,editable : false},
];

function createAUIGrid( ){

    var auiGridProps = {

            selectionMode : "multipleCells",

            showRowNumColumn : true,

            showRowCheckColumn : false,

            showStateColumn : true,

            enableColumnResize : false,

            enableMovingColumn : false
        };

        // 실제로 #grid_wrap 에 그리드 생성
        mstGridID = AUIGrid.create("#grid_wrap", columnLayout, auiGridProps);

}


$(document).ready(function(){

    //PosModuleTypeComboBox
    var moduleParam = {groupCode : 143, codeIn : [2390, 2391]};
    CommonCombo.make('posType', "/sales/pos/selectPosModuleCodeList", moduleParam , '', optionModule);

//   //PosModuleTypeComboBox
//    var stockgradecomboData = [ {"codeId": "A","codeName": "Active"} ,{"codeId": "C","codeName": "Completed"} ,{"codeId": "R","codeName": "Rejected"}  ];
//    doDefCombo(stockgradecomboData, '' ,'status', 'S', '');


    //selectStatusCodeList
    var statusParam = {groupCode : 9};
    CommonCombo.make('status', "/sales/pos/selectStatusCodeList", statusParam , '', optionSystem);

    //branch List
    CommonCombo.make('branch', "/sales/pos/selectWhBrnchList", '' , '', '');


   createAUIGrid();

//    createAUIGridExcel(excelLayout);

});


$(function(){
	 $('#btnAddItem').click(function() {
         Common.popupDiv("/sales/posstock/eshopItemRegisterPop.do");
     });

	  $('#btnEditItem').click(function() {
	      Common.popupDiv("/sales/posstock/eshopItemEditPop.do");
	  });


});



</script>

<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Point of Sales</li>
    <li>Stock Movement</li>
    <li>e-Shop</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
    <h2>e-Shop</h2>
    <ul class="right_btns">
       <li><p class="btn_blue"><a id="orderBtn"  onclick="javascript:fn_selectPosStockMgmtAddPop();" ><span class="add"></span>ORDER</a></p></li>
       <li><p class="btn_blue"><a id="receivedBtn"  onclick="javascript:fn_selectPosStockMgmtNewAdjPop();" ><span class="edit"></span> RECEIVED</a></p></li>
       <li><p class="btn_blue"><a id="approvalBtn"  onclick="javascript:fn_selectPosStockMgmtApprovalPop();" ><span class="edit"></span>APPROVAL</a></p></li>
       <li><p class="btn_blue"><a id="searchBtn" onclick="javascript:fn_getDataListAjax();"  ><span class="search"   ></span>Search</a></p></li>
       <li><p class="btn_blue"><a id="clearBtn"><span class="clear"></span>Clear</a></p></li>
    </ul>
</aside><!-- title_line end -->

<form id="searchForm" name="searchForm" method="post" onsubmit="return false;">
<section class="search_table"><!-- search_table start -->
        <table summary="search table" class="type1"><!-- table start -->
            <caption>search table</caption>
            <colgroup>
                <col style="width:150px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
                <col style="width:160px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
             <tr>
                   <th scope="row">POS Type</th>
                   <td>
                         <select class="w100p" id="posType"  name="posType"></select>
                   </td>
                   <th scope="row">Reference No.</th>
                   <td>
                        <input  type="text" id="refNo" name="refNo"  ></input>
                   </td>
                   <th scope="row">Status</th>
                   <td>
                        <select class="w100p" id="status" name="status"></select>
                   </td>
             </tr>

             <tr>
                    <th scope="row">Sales Date</th>
                    <td >
                        <div class="date_set w100p"><!-- date_set start -->
                        <p><input id="fromSalesDt" name="fromSalesDt" type="text" title="Create start Date" value="${bfDay}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        <span> To </span>
                        <p><input id="toSalesDt" name="toSalesDt" type="text" title="Create End Date" value="${toDay}" placeholder="DD/MM/YYYY" class="j_date"></p>
                        </div><!-- date_set end -->
                    </td>

                   <th scope="row">Member ID</th>
                   <td>
                        <input  type="text" id="memberId" name="memberId"  ></input>
                   </td>

                   <th scope="row">Branch</th>
                   <td>
                        <select  id="branch"  name="branch" class="w100p"></select>
                   </td>
            </tr>

             <tr>
                   <th scope="row">Org Code</th>
                   <td>
                        <input  type="text" id="orgCode" name="orgCode"  ></input>
                   </td>
                   <th scope="row">Grp Code</th>
                   <td>
                        <input  type="text" id="grpCode" name="grpCode"  ></input>
                   </td>
                   <th scope="row">Dept Code</th>
                   <td>
                        <input  type="text" id="deptCode" name="deptCode"  ></input>
                   </td>
              </tr>
            </tbody>
        </table><!-- table end -->
    </section><!-- search_table end -->


  </form>

<aside class="link_btns_wrap">
    <!-- link_btns_wrap start -->
    <p class="show_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link.gif" alt="link show" /></a></p>
    <dl class="link_list">
     <dt>Link</dt>
     <dd>
      <ul class="btns">
        <li><p class="link_btn type2"><a id="btnAddItem" href="#">Add Item</a></p></li>
        <li><p class="link_btn type2"><a id="btnEditItem" href="#">Edit Item</a></p></li>
        <li><p class="link_btn type2"><a href="#">Shipping</a></p></li>
      </ul>
      <p class="hide_btn">
       <a href="#"><img
        src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif"
        alt="hide" /></a>
      </p>
     </dd>
    </dl>
</aside>

    <!-- data body start -->
    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
            <li><p class="btn_grid"><a id="updateStatus" >Update Info</a></p></li>
        </ul>

         <div id="grid_wrap" class="mt10" style="height:430px;"></div>
         <div id="grid_wrap_excel" class="mt10" style="height:430px;display:none;"></div>

         <ul class="center_btns mt20">
    </ul>

 </section><!-- search_result end -->

</section>