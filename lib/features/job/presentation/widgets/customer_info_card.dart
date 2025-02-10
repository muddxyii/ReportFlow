import 'package:flutter/material.dart';
import 'package:reportflow/core/models/report_flow_types.dart';
import 'package:reportflow/core/widgets/form_input_field.dart';
import 'package:reportflow/core/widgets/info_field.dart';

class CustomerInfoCard extends StatefulWidget {
  final CustomerInformation info;

  final Function(CustomerInformation) onInfoUpdate;

  const CustomerInfoCard({
    super.key,
    required this.info,
    required this.onInfoUpdate,
  });

  @override
  State<CustomerInfoCard> createState() => _CustomerInfoCardState();
}

class _CustomerInfoCardState extends State<CustomerInfoCard> {
  bool _isEditingOwner = false;
  bool _isEditingRepresentative = false;
  bool _isOwnerExpanded = false;
  bool _isRepresentativeExpanded = false;

  final _ownerFormKey = GlobalKey<FormState>();
  final _representativeFormKey = GlobalKey<FormState>();

  final _ownerNameFocus = FocusNode();
  final _ownerAddressFocus = FocusNode();
  final _ownerEmailFocus = FocusNode();
  final _ownerContactFocus = FocusNode();
  final _ownerPhoneFocus = FocusNode();

  final _representativeNameFocus = FocusNode();
  final _representativeAddressFocus = FocusNode();
  final _representativeContactFocus = FocusNode();
  final _representativePhoneFocus = FocusNode();

  late FacilityOwnerInfo _editedOwnerInfo;
  late RepresentativeInfo _editedRepresentativeInfo;

  @override
  void initState() {
    super.initState();
    _editedOwnerInfo = widget.info.facilityOwnerInfo;
    _editedRepresentativeInfo = widget.info.representativeInfo;
  }

  @override
  void didUpdateWidget(CustomerInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.info != widget.info) {
      _editedOwnerInfo = widget.info.facilityOwnerInfo;
      _editedRepresentativeInfo = widget.info.representativeInfo;
    }
  }

  @override
  void dispose() {
    _ownerNameFocus.dispose();
    _ownerAddressFocus.dispose();
    _ownerEmailFocus.dispose();
    _ownerContactFocus.dispose();
    _ownerPhoneFocus.dispose();

    _representativeNameFocus.dispose();
    _representativeAddressFocus.dispose();
    _representativeContactFocus.dispose();
    _representativePhoneFocus.dispose();

    super.dispose();
  }

  void _toggleOwnerEdit() {
    setState(() {
      _isEditingOwner = !_isEditingOwner;
      if (!_isEditingOwner) {
        _editedOwnerInfo = widget.info.facilityOwnerInfo;
      }
    });
  }

  void _toggleRepresentativeEdit() {
    setState(() {
      _isEditingRepresentative = !_isEditingRepresentative;
      if (!_isEditingRepresentative) {
        _editedRepresentativeInfo = widget.info.representativeInfo;
      }
    });
  }

  void _saveOwnerInfo() {
    if (_ownerFormKey.currentState?.validate() ?? false) {
      _ownerFormKey.currentState?.save();
      final updatedInfo = CustomerInformation(
        facilityOwnerInfo: _editedOwnerInfo,
        representativeInfo: widget.info.representativeInfo,
      );
      widget.onInfoUpdate(updatedInfo);
      _toggleOwnerEdit();
    } else {
      final ownerNameField = _ownerNameFocus.context
          ?.findAncestorWidgetOfExactType<TextFormField>();
      if (ownerNameField?.controller?.text.isEmpty ?? true) {
        _ownerNameFocus.requestFocus();
      } else {
        _ownerAddressFocus.requestFocus();
      }
    }
  }

  void _saveRepresentativeInfo() {
    if (_representativeFormKey.currentState?.validate() ?? false) {
      _representativeFormKey.currentState?.save();
      final updatedInfo = CustomerInformation(
        facilityOwnerInfo: widget.info.facilityOwnerInfo,
        representativeInfo: _editedRepresentativeInfo,
      );
      widget.onInfoUpdate(updatedInfo);
      _toggleRepresentativeEdit();
    } else {
      final representativeNameField = _representativeNameFocus.context
          ?.findAncestorWidgetOfExactType<TextFormField>();
      if (representativeNameField?.controller?.text.isEmpty ?? true) {
        _representativeNameFocus.requestFocus();
      } else {
        _representativeAddressFocus.requestFocus();
      }
    }
  }

  Widget _buildOwnerTile(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Facility Owner',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isOwnerExpanded = expanded;
            if (!expanded && _isEditingOwner) {
              _isEditingOwner = false;
              _editedOwnerInfo = widget.info.facilityOwnerInfo;
            }
          });
        },
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child:
                _isEditingOwner ? _buildOwnerForm() : _buildOwnerInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerForm() {
    return Form(
      key: _ownerFormKey,
      child: Column(
        children: [
          FormInputField(
            label: 'Name',
            initialValue: _editedOwnerInfo.owner,
            validateValue: true,
            focusNode: _ownerNameFocus,
            onSaved: (value) => _editedOwnerInfo =
                _editedOwnerInfo.copyWith(owner: value ?? ''),
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(_ownerAddressFocus),
          ),
          FormInputField(
            label: 'Address',
            textInputType: TextInputType.streetAddress,
            initialValue: _editedOwnerInfo.address,
            validateValue: true,
            focusNode: _ownerAddressFocus,
            onSaved: (value) => _editedOwnerInfo =
                _editedOwnerInfo.copyWith(address: value ?? ''),
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(_ownerEmailFocus),
          ),
          FormInputField(
            label: 'Email',
            textInputType: TextInputType.emailAddress,
            initialValue: _editedOwnerInfo.email == 'UNKNOWN'
                ? ''
                : _editedOwnerInfo.email,
            focusNode: _ownerEmailFocus,
            onSaved: (value) => _editedOwnerInfo = _editedOwnerInfo.copyWith(
                email: value?.isEmpty ?? true ? 'UNKNOWN' : value),
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(_ownerContactFocus),
          ),
          FormInputField(
            label: 'Contact',
            initialValue: _editedOwnerInfo.contact == 'MANAGER'
                ? ''
                : _editedOwnerInfo.contact,
            focusNode: _ownerContactFocus,
            onSaved: (value) => _editedOwnerInfo = _editedOwnerInfo.copyWith(
                contact: value?.isEmpty ?? true ? 'MANAGER' : value),
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(_ownerPhoneFocus),
          ),
          FormInputField(
            label: 'Phone',
            textInputType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            initialValue: _editedOwnerInfo.phone == 'UNKNOWN'
                ? ''
                : _editedOwnerInfo.phone,
            focusNode: _ownerPhoneFocus,
            onSaved: (value) => _editedOwnerInfo = _editedOwnerInfo.copyWith(
                phone: value?.isEmpty ?? true ? 'UNKNOWN' : value),
            onSubmitted: () => _saveOwnerInfo(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleOwnerEdit,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveOwnerInfo,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOwnerInfo(BuildContext context) {
    final info = widget.info.facilityOwnerInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoField(label: 'Name', value: info.owner),
        InfoField(label: 'Address', value: info.address),
        InfoField(label: 'Email', value: info.email),
        InfoField(label: 'Contact', value: info.contact),
        InfoField(label: 'Phone', value: info.phone),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleOwnerEdit,
          ),
        ),
      ],
    );
  }

  Widget _buildRepresentativeTile(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Text(
          'Representative',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isRepresentativeExpanded = expanded;
            if (!expanded && _isEditingRepresentative) {
              _isEditingRepresentative = false;
              _editedRepresentativeInfo = widget.info.representativeInfo;
            }
          });
        },
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: _isEditingRepresentative
                ? _buildRepresentativeForm()
                : _buildRepresentativeInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildRepresentativeForm() {
    return Form(
      key: _representativeFormKey,
      child: Column(
        children: [
          FormInputField(
            label: 'Name',
            initialValue: _editedRepresentativeInfo.owner,
            validateValue: true,
            focusNode: _representativeNameFocus,
            onSaved: (value) => _editedRepresentativeInfo =
                _editedRepresentativeInfo.copyWith(owner: value ?? ''),
            onSubmitted: () => FocusScope.of(context)
                .requestFocus(_representativeAddressFocus),
          ),
          FormInputField(
            label: 'Address',
            textInputType: TextInputType.streetAddress,
            initialValue: _editedRepresentativeInfo.address,
            validateValue: true,
            focusNode: _representativeAddressFocus,
            onSaved: (value) => _editedRepresentativeInfo =
                _editedRepresentativeInfo.copyWith(address: value ?? ''),
            onSubmitted: () => FocusScope.of(context)
                .requestFocus(_representativeContactFocus),
          ),
          FormInputField(
            label: 'Contact',
            initialValue: _editedRepresentativeInfo.contact == 'MANAGER'
                ? ''
                : _editedRepresentativeInfo.contact,
            focusNode: _representativeContactFocus,
            onSaved: (value) => _editedRepresentativeInfo =
                _editedRepresentativeInfo.copyWith(
                    contact: value?.isEmpty ?? true ? 'MANAGER' : value),
            onSubmitted: () =>
                FocusScope.of(context).requestFocus(_representativePhoneFocus),
          ),
          FormInputField(
            label: 'Phone',
            textInputType: TextInputType.phone,
            textInputAction: TextInputAction.done,
            initialValue: _editedRepresentativeInfo.phone == 'UNKNOWN'
                ? ''
                : _editedOwnerInfo.phone,
            focusNode: _representativePhoneFocus,
            onSaved: (value) => _editedRepresentativeInfo =
                _editedRepresentativeInfo.copyWith(
                    phone: value?.isEmpty ?? true ? 'UNKNOWN' : value),
            onSubmitted: () => _saveRepresentativeInfo(),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: _toggleRepresentativeEdit,
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _saveRepresentativeInfo,
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRepresentativeInfo(BuildContext context) {
    final info = widget.info.representativeInfo;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoField(label: 'Name', value: info.owner),
        InfoField(label: 'Address', value: info.address),
        InfoField(label: 'Contact', value: info.contact),
        InfoField(label: 'Phone', value: info.phone),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _toggleRepresentativeEdit,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildOwnerTile(context),
        const SizedBox(height: 8),
        _buildRepresentativeTile(context),
      ],
    );
  }
}
