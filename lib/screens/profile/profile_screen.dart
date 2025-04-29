import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_registration/models/user_model.dart';
import 'package:student_registration/providers/auth_provider.dart';
import 'package:student_registration/utils/validators.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _studentIdController;
  late String _selectedDepartment;
  bool _isEditing = false;
  bool _isSaving = false;
  
  final List<String> _departments = [
    'Computer Science',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Engineering',
    'Business',
    'Economics',
    'Psychology',
    'History',
    'Literature',
    'Arts',
  ];
  
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _studentIdController = TextEditingController(text: user?.studentId ?? '');
    _selectedDepartment = user?.department ?? _departments[0];
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _studentIdController.dispose();
    super.dispose();
  }
  
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isSaving = true;
    });
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;
    
    if (user != null) {
      final updatedUser = user.copyWith(
        name: _nameController.text.trim(),
        studentId: _studentIdController.text.trim(),
        department: _selectedDepartment,
      );
      
      await authProvider.updateUserProfile(updatedUser);
      
      if (mounted) {
        setState(() {
          _isEditing = false;
          _isSaving = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    
    if (user == null) {
      return Center(
        child: Text('User not found'),
      );
    }
    
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                // Profile picture
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor,
                  backgroundImage: user.photoUrl.isNotEmpty
                      ? NetworkImage(user.photoUrl)
                      : null,
                  child: user.photoUrl.isEmpty
                      ? Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : 'S',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
                SizedBox(height: 16),
                
                // User name
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                
                // User email
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 16),
                
                // Edit button
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isEditing = !_isEditing;
                    });
                  },
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  label: Text(_isEditing ? 'Cancel' : 'Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isEditing ? Colors.grey : null,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          
          // Profile details
          Text(
            'Profile Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          
          // Error message
          if (authProvider.error.isNotEmpty)
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red[300]!),
              ),
              child: Text(
                authProvider.error,
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
          
          // Profile form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  enabled: _isEditing,
                  validator: Validators.validateName,
                ),
                SizedBox(height: 16),
                
                // Email field (disabled)
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  enabled: false,
                ),
                SizedBox(height: 16),
                
                // Student ID field
                TextFormField(
                  controller: _studentIdController,
                  decoration: InputDecoration(
                    labelText: 'Student ID',
                    prefixIcon: Icon(Icons.badge),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  enabled: _isEditing,
                  validator: Validators.validateStudentId,
                ),
                SizedBox(height: 16),
                
                // Department dropdown
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    prefixIcon: Icon(Icons.business),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _departments.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: _isEditing
                      ? (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedDepartment = newValue;
                            });
                          }
                        }
                      : null,
                ),
                SizedBox(height: 24),
                
                // Save button
                if (_isEditing)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _isSaving
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 32),
          
          // Enrolled courses count
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.school,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enrolled Courses',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        user.enrolledCourses.length.toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

