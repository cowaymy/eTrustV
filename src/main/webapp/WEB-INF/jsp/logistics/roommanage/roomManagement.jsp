<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>

<style type="text/css">

/* 커스텀 칼럼 스타일 정의 */
.aui-grid-user-custom-left {
    text-align:left;
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
<link rel="stylesheet" href="http://code.jquery.com/ui/1.11.1/themes/smoothness/jquery-ui.css">
<script type="text/javascript" src="${pageContext.request.contextPath}/resources/js/jquery.blockUI.min.js"></script>
<script type="text/javaScript" language="javascript">


    // AUIGrid 생성 후 반환 ID
    var myGridID;
    
    var comboData = [{"codeId": "1","codeName": "Active"},{"codeId": "8","codeName": "Inactive"}];
    
    var url;
    // AUIGrid 칼럼 설정                                                                            visible : false
    var columnLayout = [{dataField:"assetid"      ,headerText:"Asset ID"           ,width:"5%"  ,height:30 , visible:true},
                        {dataField:"name2"      ,headerText:"Status"           ,width:"8%" ,height:30 , visible:true},
                        {dataField:"codename2"    ,headerText:"Type"    ,width:"12%" ,height:30 , visible:true},
                        {dataField:"name"   ,headerText:"Brand"       ,width:120 ,height:30 , visible:true},
                        {dataField:"name1"   ,headerText:"Model Name"       ,width:140 ,height:30 , visible:true},
                        {dataField:"codename1"   ,headerText:"Color"       ,width:90 ,height:30 , visible:true},
                        {dataField:"branch"    ,headerText:"Branch"        ,width:120 ,height:30 , visible:true},
                        {dataField:"department"    ,headerText:"Department"        ,width:140 ,height:30 , visible:true},
                        {dataField:"purchsdt"    ,headerText:"Purchase Date"        ,width:120 ,height:30 , visible:true},
                        {dataField:"username2"    ,headerText:"Current User"        ,width:120  ,height:30 , visible:true},
                        {dataField:"refno"    ,headerText:"Ref No"        ,width:120  ,height:30 , visible:true},
                        {dataField:"dealername"    ,headerText:"Dealer"        ,width:120  ,height:30 , visible:true},
                        {dataField:"invcno"    ,headerText:"Inv No"        ,width:120 ,height:30 , visible:true},                     
                        {dataField:"brandid"  ,headerText:"brandId"     ,width:100 ,height:30 , visible:false},
                        {dataField:"ctgryid"    ,headerText:"ctgryId"        ,width:100 ,height:30 , visible:false},                      
                        {dataField:"codename"    ,headerText:"codeName"        ,width:100 ,height:30 , visible:false},                      
                        {dataField:"colorId"  ,headerText:"codeName1"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"crtdt"   ,headerText:"crtDt"       ,width:100 ,height:30 , visible:false},                       
                        {dataField:"crtuserid"      ,headerText:"crtUserId"          ,width:100 ,height:30 , visible:false},
                        {dataField:"currbrnchid"      ,headerText:"currBrnchId"          ,width:100 ,height:30 , visible:false},                        
                        {dataField:"currdeptid"     ,headerText:"currDeptId"         ,width:100 ,height:30 , visible:false},                    
                        {dataField:"curruserid"     ,headerText:"currUserId"         ,width:100 ,height:30 , visible:false},                      
                        {dataField:"username"       ,headerText:"userName2"           ,width:100 ,height:30 , visible:false},                       
                        {dataField:"imeino"       ,headerText:"imeiNo"           ,width:100 ,height:30 , visible:false},                      
                        {dataField:"macaddr"  ,headerText:"macAddr"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"purchsamt"   ,headerText:"purchsAmt"       ,width:100 ,height:30 , visible:false},                      
                        {dataField:"assetrem"   ,headerText:"assetRem"         ,width:"15%" ,height:30 , visible:false},                       
                        {dataField:"serialno"      ,headerText:"serialNo"          ,width:100 ,height:30 , visible:false},                        
                         {dataField:"stusid"      ,headerText:"stusId"          ,width:100 ,height:30 , visible:false},                 
                        {dataField:"typeid"     ,headerText:"typeId"           ,width:"15%" ,height:30 , visible:false},                   
                        {dataField:"upddt"     ,headerText:"updDt"         ,width:"10%" ,height:30 , visible:false},                      
                        {dataField:"upduserid"    ,headerText:"upd_user_Id"        ,width:100 ,height:30 , visible:false},
                        {dataField:"username1"  ,headerText:"userName1"      ,width:100 ,height:30 , visible:false},                       
                        {dataField:"wrantyno"  ,headerText:"wrantyNo"      ,width:100 ,height:30 , visible:false},                      
                        {dataField:"dealerid"  ,headerText:"dealerId"      ,width:100 ,height:30 , visible:false},
                       ];
    
    
 /* 그리드 속성 설정
  usePaging : true, pageRowCount : 30,  fixedColumnCount : 1,// 페이지 설정
  editable : false,// 편집 가능 여부 (기본값 : false) 
  enterKeyColumnBase : true,// 엔터키가 다음 행이 아닌 다음 칼럼으로 이동할지 여부 (기본값 : false)
  selectionMode : "multipleCells",// 셀 선택모드 (기본값: singleCell)                
  useContextMenu : true,// 컨텍스트 메뉴 사용 여부 (기본값 : false)                
  enableFilter : true,// 필터 사용 여부 (기본값 : false)            
  useGroupingPanel : true,// 그룹핑 패널 사용
  showStateColumn : true,// 상태 칼럼 사용
  displayTreeOpen : true,// 그룹핑 또는 트리로 만들었을 때 펼쳐지게 할지 여부 (기본값 : false)
  noDataMessage : "출력할 데이터가 없습니다.",
  groupingMessage : "여기에 칼럼을 드래그하면 그룹핑이 됩니다.",
  rowIdField : "stkid",
  enableSorting : true,
  showRowCheckColumn : true,
  */
    var gridoptions = {showStateColumn : false , editable : false, pageRowCount : 30, usePaging : true, useGroupingPanel : false };
    
    var subgridpros = {
            // 페이지 설정
            usePaging : true,                
            pageRowCount : 10,                
            editable : true,                
            noDataMessage : "<spring:message code='sys.info.grid.noDataMessage'/>",
            enableSorting : true,
            softRemoveRowMode:false
            };
    

    $(document).ready(function(){
        // masterGrid 그리드를 생성합니다.
        myGridID = GridCommon.createAUIGrid("grid_wrap", columnLayout,"", gridoptions);
        
        doDefCombo(comboData, '' ,'searchstatus', 'A', '');
          
        doGetComboSepa('/common/selectBranchCodeList.do', '3' , ' - ' , '','searchbranchid', 'S' , ''); //청구처 리스트 조회
                
        
        AUIGrid.bind(myGridID, "cellClick", function( event )  
        {
            
            
        });
        
        // 셀 더블클릭 이벤트 바인딩
        AUIGrid.bind(myGridID, "cellDoubleClick", function(event) 
        {
        });
       
        $(function(){
            //all select 값 주기
            
            $("#search").click(function(){
            	getListAjax();    
            });
            $("#clear").click(function(){
            });
               
    });
    });
    
    
    function getListAjax() {
        var url = "/misc/room/roomManagementList.do";
        var param = $("#searchForm").serializeJSON();
        console.log(param);
        Common.ajax("POST" , url , param , function(data){
            var list= data.dataList
            console.log(list);
            AUIGrid.setGridData(myGridID, list);
        });
    }
    

       
</script>
</head>
<div id="SalesWorkDiv" class="SalesWorkDiv" style="width: 100%; height: 960px; position: static; zoom: 1;">
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Room Management</li>
    <li>List</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Room Management</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a id="search"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a id="clear"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form id="searchForm" name="searchForm" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:140px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Room ID</th>
    <td>
    <input type="text" id="searchroomId" name=""searchroomId""   placeholder="" class="w100p" />
    </td>
    <th scope="row">Room Code</th>
    <td>
     <input type="text" id="searchroomCd" name="searchroomCd"placeholder=""  class="w100p" />
    </td>
    <th scope="row">Room Name</th>
    <td>
    <input type="text" id="searchroomNm" name="searchroomNm" placeholder=""  class="w100p" />
    </td>
</tr>
<tr>
    <th scope="row">Status</th>
    <td>
    <select id="searchstatus" name="searchstatus"   title="" placeholder="" class="w100p" >
    </select>
    </td>
    <th scope="row">Branch</th>
    <td>
    <select id="searchbranchid" name="searchbranchid" class="w100p" >
    </select>
    </td>
    <th scope="row">Capacity</th>
                    <td>
                    <div class="itemPriceDate w100p">
                        <p class="short"><input type="text" title="" placeholder="" class="w100p" id="searchmin" name="searchmin" readonly="readonly"  /></p>
                        <span>To</span>
                        <p class="short"><input type="text" title="" placeholder="" class="w100p" id="searchmax" name="searchmax" readonly="readonly"/></p>
                    </div>
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
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
<!--         <li><p class="link_btn type2"><a id="copyAssetOpen">Copy Asset</a></p></li>
        <li><p class="link_btn type2"><a id="transAssetOpen">Transfer Asset (Single)</a></p></li>
        <li><p class="link_btn type2"><a id="transBulkAssetOpen">Transfer Asset (Bulk)</a></p></li>
        <li><p class="link_btn type2"><a id="returnAssetOpen">Return Asset</a></p></li>
        <li><p class="link_btn type2"><a id="statusAssetOpen">Lost / Obsolete / Deactivate</a></p></li> -->
    </ul>
    <p class="hide_btn"><a href="#"><img src="${pageContext.request.contextPath}/resources/images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->
<article class="grid_wrap"><!-- grid_wrap start -->
    <div id="grid_wrap"></div>
</article><!-- grid_wrap end -->

</section><!-- content end -->
</section>
</div>




