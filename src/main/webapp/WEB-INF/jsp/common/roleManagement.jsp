<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/tiles/view/common.jsp" %>
<script type="text/javaScript">

    var roleGridId;
    var roleViewGridId;

    var sRole = "<spring:message code='sys.label.role' />";
    var sRoleId = "<spring:message code='sys.label.role.id' />";
    var sStatus = "<spring:message code='sys.label.status' />";
    var sLevel = "<spring:message code='sys.label.level' />";

    var gridRoleColumnLayout = [{
        dataField: "roleId",
        headerText: sRoleId,
        editable: false
    }, {
        dataField: "roleLev",
        headerText: sLevel,
        editable: false
    }, {
        dataField: "lvl1",
        headerText: sRole + "(Lvl 1)",
        editable: false
    }, {
        dataField: "lvl2",
        headerText: sRole + "(Lvl 2)",
        editable: false
    }, {
        dataField: "lvl3",
        headerText: sRole + "(Lvl 3)",
        editable: false
    }, {
        dataField: "statusName",
        headerText: sStatus,
        editable: false
    }, {
        dataField: "roleDesc",
        headerText: "roleDesc",
        visible : false
    }, {
        dataField: "lvlCode1",
        headerText: "lvlCode1",
        visible : false
    }, {
        dataField: "lvlCode2",
        headerText: "lvlCode2",
        visible : false
    }, {
        dataField: "lvlCode3",
        headerText: "lvlCode3",
        visible : false
    }, {
        dataField: "stus",
        headerText: "stus",
        visible : false
    }];

    // view
    var sUserId = "<spring:message code='sys.title.user.id' />";
    var sUserName = "<spring:message code='sys.title.user.name' />";
    var sFullName = "<spring:message code='sys.title.user.fullname' />";
    var sBranchName = "<spring:message code='sys.title.branch.name' />";

    var gridViewColumnLayout = [{
        dataField: "userId",
        editable: false,
        headerText: sUserId
    }, {
        dataField: "userName",
        headerText: sUserName,
        editable: false
    }, {
        dataField: "userFullName",
        headerText: sFullName,
        editable: false
    }, {
        dataField: "name",
        headerText: sBranchName,
        editable: false
    }];

    $(function () {
        roleGridId = GridCommon.createAUIGrid("roleGridId", gridRoleColumnLayout, "", "");

        // cellClick event.
        AUIGrid.bind(roleGridId, "cellClick", function(event) {
//            console.log("rowIndex : " + event.rowIndex + ", columnIndex : " + event.columnIndex + " clicked");
            fn_viewInit();

            $("#selectedRoleId").val(AUIGrid.getCellValue(roleGridId, event.rowIndex, "roleId"));
            $("#editRoleId").val(AUIGrid.getCellValue(roleGridId, event.rowIndex, "roleId"));
        });

        var calback1 = function () {
            $('#sRole1').on("change", function () {

                var $this = $(this);

                $("#sRole2").val("");
                $("#sRole3").val("");

                if (FormUtil.isNotEmpty($this.val())) {
                    CommonCombo.make("sRole2", "/common/getRolesByParentRole.do", {
                        parentRole: $this.val()
                    }, "", {
                        id: "roleId",
                        name: "roleCode"
                    });
                }
            });
        };

        $('#sRole2').on("change", function () {

            var $this = $(this);

            $("#sRole3").val("");

            if (FormUtil.isNotEmpty($this.val())) {

                CommonCombo.make("sRole3", "/common/getRolesByParentRole.do", {
                    parentRole: $this.val()
                }, "", {
                    id: "roleId",
                    name: "roleCode"
                });

            }
        });

        CommonCombo.make("sRole1", "/common/getRootRoleList.do", {}, "", {
            id: "roleId",
            name: "roleCode"
        }, calback1);

        $("#btnSearch").on("click", function () {
            fn_getList();
        });

        $("#btnClear").on("click", function () {
            fn_initSearch();
        });


        /*
        ############################################
        viewPop
        ############################################
        */

        $("#btnViewPop").on("click", function () {
            if(FormUtil.isEmpty($("#selectedRoleId").val())){
                Common.alert("<spring:message code='sys.msg.select.list'/>");
                return false;
            }

            $("#roleViewPop").show();

            // set Info - viewPop
            var gridRowIndex = AUIGrid.getSelectedIndex(roleGridId)[0];
            $("#viewLevel").text(AUIGrid.getCellValue(roleGridId, gridRowIndex, "roleLev") + "-" + AUIGrid.getCellValue(roleGridId, gridRowIndex, "statusName"));
            $("#viewDescription").text(AUIGrid.getCellValue(roleGridId, gridRowIndex, "roleDesc"));
            $("#viewRole1").text(AUIGrid.getCellValue(roleGridId, gridRowIndex, "lvl1"));
            $("#viewRole2").text(AUIGrid.getCellValue(roleGridId, gridRowIndex, "lvl2"));

            if(FormUtil.isEmpty(roleViewGridId)){
                roleViewGridId = GridCommon.createAUIGrid("roleViewGridId", gridViewColumnLayout, "", "");
            }
            fn_getUsersByRoleId();
        });

        $("#btnViewSearch").on("click", function () {
            fn_getUsersByRoleId();
        });

        $("#btnViewAllSearch").on("click", function () {
            $("#sViewUserId").val("");
            $("#sViewKeyword").val("");
            fn_getUsersByRoleId();
        });

        $("#btnViewPopClose").on("click", function () {
            $("#roleViewPop").hide();
        });


        /*
        ############################################
        editPop
        ############################################
        */

        var isFirst = true;

        $("#btnUpdatePop").on("click", function () {
            if(FormUtil.isEmpty($("#editRoleId").val())){
                Common.alert("<spring:message code='sys.msg.select.list'/>");
                return false;
            }

            isFirst = true;
            $("#roleEditPop").show();

            var gridRowIndex = AUIGrid.getSelectedIndex(roleGridId)[0];
            var editLvl = AUIGrid.getCellValue(roleGridId, gridRowIndex, "roleLev");
            var stus = AUIGrid.getCellValue(roleGridId, gridRowIndex, "stus");


            fn_editInit(stus);

            var callbackEditRole1 = function () {

                if(isFirst) {
                    $("#editRole1").val(AUIGrid.getCellValue(roleGridId, gridRowIndex, "lvlCode1")).prop("selected", true);
                    getNextLevel($("#editRole1").val());
                }

                function getNextLevel(parentRole) {
                    if (FormUtil.isNotEmpty(parentRole)) {
                        CommonCombo.make("editRole2", "/common/getRolesByParentRole.do", {
                            parentRole: parentRole
                        }, "", {
                            id: "roleId",
                            name: "roleCode"
                        }, function () {

                            if (isFirst) {
                                $("#editRole2").val(AUIGrid.getCellValue(roleGridId, gridRowIndex, "lvlCode2")).prop("selected", true);
                                isFirst = false;
                            }
                        });
                    }
                }

                $('#editRole1').on("change", function () {
                    var $this = $(this);
                    $("#editRole2").val("");

                    getNextLevel($this.val());
                });
            };

            if(editLvl > 1) {
                CommonCombo.make("editRole1", "/common/getRootRoleList.do", {}, "", {
                    id: "roleId",
                    name: "roleCode"
                }, callbackEditRole1);
            }

            // set Info - editPop
            $("#editLevel").val(editLvl).prop("selected", true);
            $("#editDescription").val(AUIGrid.getCellValue(roleGridId, gridRowIndex, "roleDesc"));

            $("#editLevel").prop('disabled', true);

            if(editLvl == 1){
                $("#editRole1").prop('disabled', true);
                $("#editRole2").prop('disabled', true);
            }else if(editLvl == 2){
                $("#editRole1").prop('disabled', false);
                $("#editRole2").prop('disabled', true);
            }else if(editLvl == 3){
                $("#editRole1").prop('disabled', false);
                $("#editRole2").prop('disabled', false);
            }
        });

        $("#btnRoleUpdate").on("click", function () {
            fn_updateRole();
        });

        $("#btnRoleDeactivate").on("click", function () {
            fn_roleDeactivate();
        });

        $("#btnRoleActivate").on("click", function () {
            fn_roleActivate();
        });

        $("#btnUpdatePopClose").on("click", function () {
            $("#roleEditPop").hide();
        });

        /*
        ############################################
        addPop
        ############################################
         */
        $('#addLevel').on("change", function () {
            var $this = $(this);

            $("#addRole1").val("");
            $("#addRole2").val("");

            if($this.val() == 1){
                $("#addRole1").prop('disabled', true);
                $("#addRole2").prop('disabled', true);
            }else if($this.val() == 2){
                $("#addRole1").prop('disabled', false);
                $("#addRole2").prop('disabled', true);
            }else if($this.val() == 3){
                $("#addRole1").prop('disabled', false);
                $("#addRole2").prop('disabled', false);
            }
        });

        $("#btnAddPop").on("click", function () {

            fn_addInit();

            $("#roleAddPop").show();

            var callbackAddRole1 = function () {
                $('#addRole1').on("change", function () {

                    var $this = $(this);

                    $("#addRole2").val("");

                    if (FormUtil.isNotEmpty($this.val())) {
                        CommonCombo.make("addRole2", "/common/getRolesByParentRole.do", {
                            parentRole: $this.val()
                        }, "", {
                            id: "roleId",
                            name: "roleCode"
                        });
                    }
                });
            };

            CommonCombo.make("addRole1", "/common/getRootRoleList.do", {}, "", {
                id: "roleId",
                name: "roleCode"
            }, callbackAddRole1);

        });

        $("#btnAddPopClose").on("click", function () {
            $("#roleAddPop").hide();
        });

        $("#btnRoleSave").on("click", function () {
            fn_saveRole();
        });

    });


    function fn_initSearch() {
        $("#sKeyword").val("");
        $("#sRoleId").val("");

        $("#sRole1").val("");
        $("#sRole2").val("");
        $("#sRole3").val("");

        $("#sStatus").multipleSelect("checkAll");
        $("#sLevel").multipleSelect("checkAll");
    }

    function fn_getList() {
        Common.ajax("GET", "/common/getRoleManagementList.do", $("#searchForm").serialize(), function (data) {
            AUIGrid.setGridData(roleGridId, data);
        });
    }

    function fn_getUsersByRoleId(){
        Common.ajax("GET", "/common/getUsersByRoleId.do", $("#searchViewForm").serialize(), function (data) {
            AUIGrid.setGridData(roleViewGridId, data);
        });
    }

    function fn_viewInit(){
        $("#selectedRoleId").val("");

        $("#viewDescription").text("");
        $("#viewLevel").text("");
        $("#viewRole1").text("");
        $("#viewRole2").text("");
    }

    function fn_saveRole() {

        if(!fn_isValidateAddRole()){
            return false;
        }

        var parentRole = "";
        var addlvl = $("#addLevel option:selected").val();
        var addRole1 = $("#addRole1 option:selected").val();
        var addRole2= $("#addRole2 option:selected").val();

        if(addlvl == 1){
            parentRole = 0;
        }else if(addlvl == 2){
            parentRole = addRole1;
        }else if(addlvl == 3){
            parentRole = addRole2;
        }else{
            Common.alert("Invalid addlvl.........");
        }

        var formJson = $("#roleAddForm").serializeJSON();
        formJson = $.extend(formJson, {
            parentRole : parentRole
        });

        Common.ajax("POST", "/common/saveRole.do", formJson, function(result) {
            fn_addInit();
            Common.alert("<spring:message code='sys.msg.success'/>");
        });
    }

    function fn_addInit() {
        $("#addLevel").val("1").prop("selected", true);

        $("#addDescription").val("");

        $("#addRole1").val("");
        $("#addRole2").val("");

        $("#addRole1").prop('disabled', true);
        $("#addRole2").prop('disabled', true);
    }
    
    function fn_isValidateAddRole() {

        var addlvl = $("#addLevel option:selected").val();
        var addRole1 = $("#addRole1 option:selected").val();
        var addRole2= $("#addRole2 option:selected").val();
        var description = $("#addDescription").val();

        if(FormUtil.isEmpty(addlvl)){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Level' htmlEscape='false'/>");
            return false;
        }

        if(addlvl == 2){
            if(FormUtil.isEmpty(addRole1)){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Role1' htmlEscape='false'/>");
                return false;
            }
        }

        if(addlvl == 3){
            if(FormUtil.isEmpty(addRole1)){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Role1' htmlEscape='false'/>");
                return false;
            }

            if(FormUtil.isEmpty(addRole2)){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Role2' htmlEscape='false'/>");
                return false;
            }
        }

        if(FormUtil.isEmpty(description)){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='description' htmlEscape='false'/>");
            return false;
        }

        return true;
    }

    function fn_roleActivate(){
        Common.ajax("POST", "/common/updateActivateRole.do", $("#roleEditForm").serializeJSON(), function(result) {
            fn_editInit(1);
            Common.alert("<spring:message code='sys.msg.success'/>");
        });
    }

    function fn_roleDeactivate(){
        Common.ajax("POST", "/common/updateDeactivateRole.do", $("#roleEditForm").serializeJSON(), function(result) {
            fn_editInit(8);
            Common.alert("<spring:message code='sys.msg.success'/>");
        });
    }

    function fn_updateRole(){

        if(!fn_isValidateEditRole()){
            return false;
        }

        var parentRole = "";

        var parentRole = "";
        var editlvl = $("#editLevel option:selected").val();
        var editRole1 = $("#editRole1 option:selected").val();
        var editRole2= $("#editRole2 option:selected").val();

        if(editlvl == 1){
            parentRole = 0;
        }else if(editlvl == 2){
            parentRole = editRole1;
        }else if(editlvl == 3){
            parentRole = editRole2;
        }else{
            Common.alert("Invalid editlvl.........");
        }

        var formJson = $("#roleEditForm").serializeJSON();
        formJson = $.extend(formJson, {
            parentRole : parentRole
        });

        Common.ajax("POST", "/common/updateRole.do", formJson, function(result) {
            Common.alert("<spring:message code='sys.msg.success'/>");
        });
    }

    function fn_isValidateEditRole() {

        var editlvl = $("#editLevel option:selected").val();

        var editRole1 = $("#editRole1 option:selected").val();
        var editRole2= $("#editRole2 option:selected").val();
        var description = $("#editDescription").val();

        if(editlvl == 2){
            if(FormUtil.isEmpty(editRole1)){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Role1' htmlEscape='false'/>");
                return false;
            }
        }

        if(editlvl == 3){
            if(FormUtil.isEmpty(editRole1)){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Role1' htmlEscape='false'/>");
                return false;
            }

            if(FormUtil.isEmpty(editRole2)){
                Common.alert("<spring:message code='sys.msg.necessary' arguments='Role2' htmlEscape='false'/>");
                return false;
            }
        }

        if(FormUtil.isEmpty(description)){
            Common.alert("<spring:message code='sys.msg.necessary' arguments='Description' htmlEscape='false'/>");
            return false;
        }

        return true;
    }

    function fn_editInit(stus) {
        if(stus == 1){
            $("#btnRoleDeactivate").show();
            $("#btnRoleActivate").hide();
            $("#btnRoleUpdate").show();
        }else{
            $("#btnRoleDeactivate").hide();
            $("#btnRoleActivate").show();
            $("#btnRoleUpdate").hide();
        }
    }

</script>

<section id="content"><!-- content start -->
    <ul class="path">
        <li><img src="${pageContext.request.contextPath}/resources/images/common/path_home.gif" alt="Home"/></li>
        <li>System</li>
        <li>Role Management</li>
    </ul>

    <aside class="title_line"><!-- title_line start -->
        <p class="fav"><a href="javascript:void(0);" class="click_add_on">System</a></p>
        <h2>Role Management</h2>
        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_blue"><a href="javascript:void (0);" id="btnSearch"><span class="search"></span><spring:message code='sys.btn.search'/></a></p>
            </li>
</c:if>
            <li><p class="btn_blue"><a href="javascript:void (0);" id="btnClear"><span class="clear"></span><spring:message code='sys.btn.clear'/></a></p>
            </li>
        </ul>
    </aside><!-- title_line end -->


    <section class="search_table"><!-- search_table start -->
        <form action="" id="searchForm" method="post">

            <table class="type1"><!-- table start -->
                <caption>table</caption>
                <colgroup>
                    <col style="width:180px"/>
                    <col style="width:*"/>
                    <col style="width:180px"/>
                    <col style="width:*"/>
                    <col style="width:180px"/>
                    <col style="width:*"/>
                </colgroup>
                <tbody>
                <tr>
                    <th scope="row"><spring:message code='sys.label.role'/> (Lvl 1)</th>
                    <td>
                        <select class="w100p" id="sRole1" name="role1">
                        </select>
                    </td>
                    <th scope="row"><spring:message code='sys.label.role'/> (Lvl 2)</th>
                    <td>
                        <select class="w100p" id="sRole2" name="role2">
                        </select>
                    </td>
                    <th scope="row"><spring:message code='sys.label.role'/> (Lvl 3)</th>
                    <td>
                        <select class="w100p" id="sRole3" name="role3">
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='sys.label.keyword'/></th>
                    <td><input type="text" title="" placeholder="" class="w100p" id="sKeyword" name="keyword"/></td>
                    <th scope="row"><spring:message code='sys.label.status'/></th>
                    <td>
                        <select class="multy_select w100p" multiple="multiple" id="sStatus" name="status">
                            
                            <option value="1" selected>Active</option>
                            <option value="8">InActive</option>
                        </select>
                    </td>
                    <th scope="row"><spring:message code='sys.label.level'/></th>
                    <td>
                        <select class="multy_select w100p" multiple="multiple" id="sLevel" name="level">
                            
                            <option value="1" selected>Level1</option>
                            <option value="2" selected>Level2</option>
                            <option value="3" selected>Level3</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row"><spring:message code='sys.label.role.id'/></th>
                    <td colspan="5"><input type="text" title="" placeholder="" class="" id="sRoleId" name="roleId"/>
                    </td>
                </tr>
                </tbody>
            </table><!-- table end -->

        </form>
    </section><!-- search_table end -->

    <section class="search_result"><!-- search_result start -->

        <ul class="right_btns">
<c:if test="${PAGE_AUTH.funcView == 'Y'}">
            <li><p class="btn_grid"><a href="javascript:void(0);" id="btnViewPop"><spring:message code='sys.btn.view'/></a></p></li>
</c:if>
<c:if test="${PAGE_AUTH.funcChange == 'Y'}">
            <li><p class="btn_grid"><a href="javascript:void(0);" id="btnUpdatePop"><spring:message code='sys.btn.edit'/></a></p></li>
            <li><p class="btn_grid"><a href="javascript:void(0);" id="btnAddPop"><spring:message code='sys.btn.add'/></a></p></li>
</c:if>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="roleGridId"></div>
        </article><!-- grid_wrap end -->

    </section><!-- search_result end -->

</section>
<!-- content end -->

</section><!-- container end -->

<!-- ######################################################################### -->
<!-- View Pop -->
<!-- ######################################################################### -->
<div id="roleViewPop" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Role Management - View Role</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="javascript:void(0);" id="btnViewPopClose"><spring:message code='sys.btn.close' /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->

        <aside class="title_line"><!-- title_line start -->
            <h2><spring:message code='sys.label.role' /> <spring:message code='sys.label.info' /></h2>
        </aside><!-- title_line end -->

        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code='sys.label.level' /></th>
                <td><span id="viewLevel"></span></td>
                <th scope="row"><spring:message code='sys.label.description' /></th>
                <td><div  id="viewDescription"></div> </td>
            </tr>
            <tr>
                <th scope="row"><spring:message code='sys.label.role' /> (Lvl 1)</th>
                <td><div  id="viewRole1"></div></td>
                <th scope="row"><spring:message code='sys.label.role' /> (Lvl 2)</th>
                <td><div  id="viewRole2"></div></td>
            </tr>
            </tbody>
        </table><!-- table end -->

        <aside class="title_line"><!-- title_line start -->
            <h2><spring:message code='sys.label.role.management.view' /></h2>
        </aside><!-- title_line end -->

        <form action="" id="searchViewForm" method="post">
        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code='sys.title.user.id' /></th>
                <td><input type="text" title="" placeholder="" class="w100p" id="sViewUserId" name="userId" /></td>
                <th scope="row">Keyword</th>
                <td><input type="text" title="" placeholder="" class="w100p" id="sViewKeyword" name="keyword" /></td>
            </tr>
            </tbody>
        </table><!-- table end -->

            <input type="hidden" id="selectedRoleId" name="roleId"/>

        </form> <!-- viewSearchForm end -->

        <ul class="right_btns">
            <li><p class="btn_grid"><a href="javascript:void(0);" id="btnViewSearch"><spring:message code='sys.btn.search'/></a></p></li>
            <li><p class="btn_grid"><a href="javascript:void(0);" id="btnViewAllSearch"><spring:message code='sys.btn.all'/></a></p></li>
        </ul>

        <article class="grid_wrap"><!-- grid_wrap start -->
            <div id="roleViewGridId"></div>
        </article><!-- grid_wrap end -->

    </section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<!-- ######################################################################### -->
<!-- Edit Pop -->
<!-- ######################################################################### -->
<div id="roleEditPop" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Role Management - Edit Role</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="javascript:void(0);" id="btnUpdatePopClose"><spring:message code='sys.btn.close' /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form action="" id="roleEditForm" method="post">
        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>



            <tbody>
            <tr>
                <th scope="row"><spring:message code='sys.label.level' /><span class="must">*</span></th>
                <td>
                    <select class="w100p" id="editLevel" name="roleLev">
                        <option value="1">Level1</option>
                        <option value="2">Level2</option>
                        <option value="3">Level3</option>
                    </select>
                </td>
                <th scope="row"><spring:message code='sys.label.description' /><span class="must">*</span></th>
                <td><input type="text" title="" placeholder="" class="w100p" id="editDescription" name="roleDesc" /></td>
            </tr>
            <tr>
                <th scope="row"><spring:message code='sys.label.role' /> (Lvl 1)<span class="must">*</span></th>
                <td>
                    <select class="w100p" id="editRole1" name="role1">
                    </select>
                </td>
                <th scope="row"><spring:message code='sys.label.role' /> (Lvl 2)<span class="must">*</span></th>
                <td>
                    <select class="w100p" id="editRole2" name="role2">
                    </select>
                </td>
            </tr>
            </tbody>
        </table><!-- table end -->

            <input type="hidden" id="editRoleId" name="roleId"/>

        </form>

        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnRoleUpdate"><spring:message code='sys.btn.update' /></a></p></li>
            <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnRoleActivate"><spring:message code='sys.btn.activate' /></a></p></li>
            <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnRoleDeactivate"><spring:message code='sys.btn.deactivate' /></a></p></li>
        </ul>

    </section><!-- pop_body end -->

</div><!-- popup_wrap end -->

<!-- ######################################################################### -->
<!-- Add Pop -->
<!-- ######################################################################### -->
<div id="roleAddPop" class="popup_wrap" style="display: none;"><!-- popup_wrap start -->

    <header class="pop_header"><!-- pop_header start -->
        <h1>Role Management - Add New Role</h1>
        <ul class="right_opt">
            <li><p class="btn_blue2"><a href="javascript:void(0);" id="btnAddPopClose"><spring:message code='sys.btn.close' /></a></p></li>
        </ul>
    </header><!-- pop_header end -->

    <section class="pop_body"><!-- pop_body start -->
        <form action="" id="roleAddForm" method="post">
        <table class="type1"><!-- table start -->
            <caption>table</caption>
            <colgroup>
                <col style="width:140px" />
                <col style="width:*" />
                <col style="width:140px" />
                <col style="width:*" />
            </colgroup>
            <tbody>
            <tr>
                <th scope="row"><spring:message code='sys.label.level' /><span class="must">*</span></th>
                <td>
                    <select class="w100p" id="addLevel" name="roleLev">
                        <option value="1">Level1</option>
                        <option value="2">Level2</option>
                        <option value="3">Level3</option>
                    </select>
                </td>
                <th scope="row"><spring:message code='sys.label.description' /><span class="must">*</span></th>
                <td><input type="text" title="" placeholder="" class="w100p" id="addDescription" name="roleDesc" /></td>
            </tr>
            <tr>
                <th scope="row"><spring:message code='sys.label.role' /> (Lvl 1)<span class="must">*</span></th>
                <td>
                    <select class="w100p" id="addRole1" name="role1">
                    </select>
                </td>
                <th scope="row"><spring:message code='sys.label.role' /> (Lvl 2)<span class="must">*</span></th>
                <td>
                    <select class="w100p" id="addRole2" name="role2">
                    </select>
                </td>
            </tr>
            </tbody>
        </table><!-- table end -->
        </form>

        <ul class="center_btns">
            <li><p class="btn_blue2 big"><a href="javascript:void(0);" id="btnRoleSave"><spring:message code='sys.btn.save' /></a></p></li>
        </ul>

    </section><!-- pop_body end -->

</div><!-- popup_wrap end -->
