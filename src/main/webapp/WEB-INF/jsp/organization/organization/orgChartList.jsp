<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


    <script type="text/javaScript" language="javascript">

    // AUIGrid 생성 후 반환 ID
       var myHpGridID;
       var myCdGridID;
       var myCtGridID;
       
       var gridValue;
       
       var option = {
           width : "1000px", // 창 가로 크기
           height : "600px" // 창 세로 크기
       };
   


    //Combo Data
    var memberTypeData = [{"codeId": "1","codeName": "Health Planner"},{"codeId": "2","codeName": "Coway Lady"},{"codeId": "3","codeName": "Coway Technician"}];


        function createAUIGrid(){
        // AUIGrid 칼럼 설정
        var columnLayout = [ {
                    dataField : "c1",
                    headerText : " ",
                    width : 390
             }, {
                    dataField : "memLvl",
                    headerText : "Member  Name",
                    width : 120,
                    visible : false
             }, {
                    dataField : "memId",
                    headerText : "Member  Name",
                    width : 120,
                    visible : false            
             }, {
                    dataField : "memLvl",
                    headerText : "Member  Name",
                    width : 120,
                    visible : false               
             }, {
                    dataField : "memType",
                    headerText : "Member  Name",
                    width : 120,
                    visible : false                                                              
             }];
            
            // 그리드 속성 설정
            var gridPros = {
                
                    treeLazyMode : true,
                    // 체크박스 대신 라디오버튼 출력함
                    //rowCheckToRadio : true,
                    selectionMode : "singleRow",
                    displayTreeOpen : true,
                    // 일반 데이터를 트리로 표현할지 여부(treeIdField, treeIdRefField 설정 필수)
                    //rowIdField : "deptCode",
                    flat2tree : true,
                      // 트리의 고유 필드명
                    //treeIdField : "deptCode",

            };

                 myHpGridID = AUIGrid.create("#grid_wrapHp", columnLayout, gridPros);
                 myCdGridID = AUIGrid.create("#grid_wrapCd", columnLayout, gridPros);
                 myCtGridID = AUIGrid.create("#grid_wrapCt", columnLayout, gridPros);
                 
                 // 트리그리드 lazyLoading 요청 이벤트 핸들러 HP
                 AUIGrid.bind(myHpGridID, "treeLazyRequest", function(event) {
                 var item = event.item;
                 var vMemLvl = item.memLvl +1;                                    
                 
                    $.ajax({
                        url: "/organization/selectHpChildList.do?memId=" + item.memId + "&memLvl=" + vMemLvl,
                        success: function(data) {
                            // 성공 시 완전한 배열 객체로 삽입하십시오.
                            event.response(data);
                            
                        }
                    }); // end of ajax
                 });
                 
                 
                 
                 // 트리그리드 lazyLoading 요청 이벤트 핸들러 CD
                 AUIGrid.bind(myCdGridID, "treeLazyRequest", function(event) {
                 var item = event.item;
                 var vMemLvl = item.memLvl +1 ;             
                 var memType = item.memType;
                 
                 console.log("data : " + event.item);                       

                    $.ajax({
                        url: "/organization/selectOrgChartCdList.do?groupCode=" + item.memId + "&memLvl=" + vMemLvl + "&memType="+memType ,
                        success: function(data) {
                            // 성공 시 완전한 배열 객체로 삽입하십시오.
                            event.response(data);
                            
                        }
                    }); // end of ajax
                 });
                 
    
    }

        
        // 화면 초기화 함수 (jQuery 의 $(document).ready(function() {}); 과 같은 역할을 합니다.
        $(document).ready(function(){


            //MemberType set 
            doDefCombo(memberTypeData, '' ,'cmbMemberType', 'S', '');   
            
            //MemberType Combo 변경시 Organization Combo 생성
            //group code = MemberType
            $('#cmbMemberType').change(function (){
                doGetCombo('/organization/getDeptTreeList.do', $(this).val() , ''   , 'cmbOrganizationId' , 'S', '');
            });
    
    
            //Organization Combo 변경시 Group Code Combo 생성
            //group code = Member Id
            $('#cmbOrganizationId').change(function (){
               // var paramdata;
                
                
                $("#groupCode").val( $(this).val());
                $("#memType").val(  $('#cmbMemberType').val() );
                $("#memLvl").val(2);
                
               // paramdata = { groupCode : $(this).val() , memType : $('#cmbMemberType').val() , memLvl:'2'};
                //doGetCombo('/organization/getGroupTreeList.do', paramdata, '','cmbGroupId', 'S' , '');
                
                doGetComboData('/organization/getGroupTreeList.do', $("#cForm").serialize(), '','cmbGroupId', 'S' , '');
                
            });
    
    
            //Group Combo 변경시  Department Combo 생성
            $('#cmbGroupId').change(function (){
                var paramdata;
                 
                $("#groupCode").val( $(this).val());
                $("#memType").val(  $('#cmbMemberType').val() );
                $("#memLvl").val(3);
                
                //paramdata = { groupCode : $(this).val() , memType : $('#cmbMemberType').val() , memLvl:'3'};
                //doGetCombo('/organization/getGroupTreeList.do', paramdata, '','cmbDepartmentCode', 'S' , '');
                doGetComboData('/organization/getGroupTreeList.do', $("#cForm").serialize(), '','cmbDepartmentCode', 'S' , '');
                
            });



    
            // AUIGrid 그리드를 생성합니다.
            createAUIGrid();
            AUIGrid.setSelectionMode(myHpGridID, "singleRow");
            AUIGrid.setSelectionMode(myCdGridID, "singleRow");
            AUIGrid.setSelectionMode(myCtGridID, "singleRow");

            fn_getOrgChartHPListAjax();
            fn_getOrgChartCdListAjax();

        });
        
        
                
        // 조회 버튼/리스트 조회.
        function fn_SelectOrgChartListAjax() {
        
            fn_getOrgChartCdListAjax();




/*             
        //ct
            Common.ajax("GET", "/organization/selectOrgChartCtList.do", $("#searchForm").serialize(), function(result) {
                
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myCtGridID, result);
            });       */      
            
            
        }
        
        
        
                // hp리스트 조회.
        function fn_getOrgChartHPListAjax() {
            var  deptId;
            var parentId;
            var cmbMemberTp = $('#cmbMemberType').val();
            var cmbDeptCode = $('#cmbDepartmentCode').val();
            var cmbGroupId = $('#cmbGroupId').val();
            var cmbOrganizationId = $('#cmbOrganizationId').val();
            var deptLevel = 1;
            
            if(cmbMemberTp == 1){
                    parentId = 124;
                    console.log("parentId : " + parentId); 
                   
            }else if (cmbMemberTp == 2){
                    parentId = 31983;
                    console.log("parentId : " + parentId); 
            }
            else if (cmbMemberTp ==3){
                    parentId = 0;
                    console.log("parentId : " + parentId);                 
            }else {
                    parentId = 3487;
                    cmbMemberTp = 1;
                    console.log("parentId : " + parentId);                 
            }
            
            
            if (cmbDeptCode != null && cmbDeptCode.length != 0){ //DeptCode 값 있을때

                deptId = cmbDeptCode;
                deptLevel = 3;
                parentId = cmbGroupId;

            } else{//DeptCode 값 없을때
                if (cmbGroupId != null && cmbGroupId.length != 0) {//그룹코드 있을때
                    deptId = cmbGroupId;
                    deptLevel = 2;
                    parentId = cmbOrganizationId;
                }  else { //그룹코드 없을때
                        if (cmbOrganizationId != null && cmbOrganizationId.length != 0) { //오가닉 코드 있을때
                            deptId = cmbOrganizationId;
                            deptLevel = 1;
                            parentId = 0;
                        }
                }
            }
            
           console.log("parentId fin : " + parentId); 
           console.log("deptLeve finl : " + deptLevel);       
           console.log("deptId fin: " + deptId);        
           console.log("deptId fin: " + cmbMemberTp);                   
           
        //hp
           var paramHpdata;
           paramHpdata = { groupCode : parentId , memType : cmbMemberTp , memLvl : deptLevel};
        
            Common.ajax("GET", "/organization/selectOrgChartHpList.do", paramHpdata, function(result) {
                
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myHpGridID, result);
            });
    }            
            
                // cd리스트 조회.
        function fn_getOrgChartCdListAjax() {
        
            var deptIdCd = 0;
            var deptLevelCd = 1;
            var parentIdCd;
            var cmbDeptCode = $('#cmbDepartmentCode').val();
            var cmbGroupIdcd = $('#cmbGroupId').val();
            var cmbOrganiIdCd = $('#cmbOrganizationId').val();
            var cmbMemberTp = $('#cmbMemberType').val();
            
            if($('#cmbMemberType').val()==1){
                parentIdCd = 124;
            }else {
                cmbMemberTp = 2;
                parentIdCd = 31983;
            }
            
            console.log("data11111111 : " + parentIdCd + ":::aaaaaa:::"+$('#cmbMemberType').val());
        
        
            if(cmbDeptCode != null && cmbDeptCode.length != 0){//DeptCode 있을때
                deptIdCd = cmbDeptCode;
                deptLevelCd = 3;
                parentIdCd = cmbGroupIdcd;
            }else {//DeptCode 없을때
                if(cmbGroupIdcd != null && cmbGroupIdcd.length !=0){
                    deptIdCd = cmbGroupIdcd;
                    deptLevelCd = 2;
                    parentIdCd =cmbOrganiIdCd;
                }else {
                    if(cmbOrganiIdCd != null && cmbOrganiIdCd.length !=0){
                        deptIdCd = cmbOrganiIdCd;
                        deptLevelCd = 1;
                    }
                }
             }   

        
           console.log("parentId fin : " + parentIdCd); 
           console.log("deptLeve finl : " + deptLevelCd);       
           console.log("deptId fin: " + deptIdCd);        
           console.log("deptId fin: " + cmbMemberTp);                   
           
           if(deptIdCd== 0){
                deptIdCd="";
           }
           
           
           if($("#cmbGroupId").val() == "" && $("#cmbOrganizationId").val() != ""){
                 parentIdCd ="0";
           }
           
            //cd
           var paramCddata;
           paramCddata = { groupCode : parentIdCd , memType : cmbMemberTp , memLvl : deptLevelCd, deptIdCd : deptIdCd};
           
                //cd
           Common.ajax("GET", "/organization/selectOrgChartCdList.do", paramCddata, function(result) {
                
                console.log("성공.");
                console.log("data : " + result);
                AUIGrid.setGridData(myCdGridID, result);
            });        
        
        }
        
        
        
        
        
        function fn_getChidListAjax() {
                Common.ajax("GET", "/organization/selectOrgChidHpList.do", $("#searchForm").serialize(), function(result) {
            });
        }
        
        
        
        
        // 그리드 초기화.
        function resetUpdatedItems() {
             AUIGrid.resetUpdatedItems(myGridID, "a");
         }
         
         
        
        

        
        
    
    </script>
    
    
    
    
<form id='cForm' name='cForm'>

    <input type='hidden' id ='groupCode' name='groupCode'>
    <input type='hidden' id ='memType' name='memType'>
    <input type='hidden' id ='memLvl' name='memLvl'>
</form>
<section id="content"><!-- content start -->
<ul class="path">
    <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home" /></li>
    <li>Organization</li>
    <li>Organization Chart</li>
</ul>

<aside class="title_line"><!-- title_line start -->
<p class="fav"><a href="#" class="click_add_on">My menu</a></p>
<h2>Organization Chart</h2>
<ul class="right_btns">
    <li><p class="btn_blue"><a href="#" onclick="javascript:fn_SelectOrgChartListAjax();"><span class="search"></span>Search</a></p></li>
    <li><p class="btn_blue"><a href="#"><span class="clear"></span>Clear</a></p></li>
</ul>
</aside><!-- title_line end -->

<section class="search_table"><!-- search_table start -->
<form action="#" method="post">

<table class="type1"><!-- table start -->
<caption>table</caption>
<colgroup>
    <col style="width:130px" />
    <col style="width:*" />
    <col style="width:160px" />
    <col style="width:*" />
</colgroup>
<tbody>
<tr>
    <th scope="row">Member Type</th>
    <td>
    <select id ="cmbMemberType" nsme = "cmbMemberType" class="w100p">
        <option value="">MemberType</option>
    </select>
    </td>
    <th scope="row">Organization Code</th>
    <td>
    <select id ="cmbOrganizationId" nsme = "cmbOrganizationId" class="w100p">
        <option value="">Organization</option>
    </select>
    </td>
</tr>
<tr>
    <th scope="row">Group Code</th>
    <td>
    <select id ="cmbGroupId" nsme = "cmbGroupId" class="w100p">
        <option value="">GroupCode</option>
    </select>
    </td>
    <th scope="row">Department Code</th>
    <td>
    <select id ="cmbDepartmentCode" nsme = "cmbDepartmentCode" class="w100p">
         <option value="">Department</option>
    </select>
    </td>
</tr>
</tbody>
</table><!-- table end -->

<aside class="link_btns_wrap"><!-- link_btns_wrap start -->
<p class="show_btn"><a href="#"><img src="../images/common/btn_link.gif" alt="link show" /></a></p>
<dl class="link_list">
    <dt>Link</dt>
    <dd>
    <ul class="btns">
        <li><p class="link_btn"><a href="#">menu1</a></p></li>
        <li><p class="link_btn"><a href="#">menu2</a></p></li>
        <li><p class="link_btn"><a href="#">menu3</a></p></li>
        <li><p class="link_btn"><a href="#">menu4</a></p></li>
        <li><p class="link_btn"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn"><a href="#">menu6</a></p></li>
        <li><p class="link_btn"><a href="#">menu7</a></p></li>
        <li><p class="link_btn"><a href="#">menu8</a></p></li>
    </ul>
    <ul class="btns">
        <li><p class="link_btn type2"><a href="#">menu1</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu3</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu4</a></p></li>
        <li><p class="link_btn type2"><a href="#">Search Payment</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu6</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu7</a></p></li>
        <li><p class="link_btn type2"><a href="#">menu8</a></p></li>
    </ul>
    <p class="hide_btn"><a href="#"><img src="../images/common/btn_link_close.gif" alt="hide" /></a></p>
    </dd>
</dl>
</aside><!-- link_btns_wrap end -->

</form>
</section><!-- search_table end -->

<section class="search_result"><!-- search_result start -->

<section class="divine3"><!-- divine3 start -->

<article>
<h3>HP Member</h3>

<article class="grid_wrapHp"><!-- grid_wrap start -->
  <!-- grid_wrap start -->
      <div id="grid_wrapHp" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article>

<article>
<h3>CD Member</h3>

<article class="grid_wrapCd"><!-- grid_wrap start -->
  <!-- grid_wrap start -->
      <div id="grid_wrapCd" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article>

<article>
<h3>CT Member</h3>

<article class="grid_wrapCt"><!-- grid_wrap start -->
  <!-- grid_wrap start -->
      <div id="grid_wrapCt" style="width: 100%; height: 334px; margin: 0 auto;"></div>
</article><!-- grid_wrap end -->

</article>

</section><!-- divine3 end -->

</section><!-- search_result end -->

</section><!-- content end -->